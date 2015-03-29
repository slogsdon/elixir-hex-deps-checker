defmodule HexDepsChecker.ErrorHandler do
  @doc false
  defmacro __using__(_) do
    quote location: :keep do
      @before_compile unquote(__MODULE__)

      defp handle_errors(conn, assigns) do
        Plug.Conn.send_resp(conn, conn.status, "Something went wrong")
      end

      defoverridable [handle_errors: 2]
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote location: :keep do
      def call(conn, opts) do
        try do
          super(conn, opts)
        catch
          kind, reason ->
            unquote(__MODULE__).__catch__(conn, kind, reason, System.stacktrace, &handle_errors/2)
        end
      end
    end
  end

  @already_sent {:plug_conn, :sent}

  @doc false
  def __catch__(conn, kind, reason, stack, handle_errors) do
    receive do
      @already_sent ->
        send self(), @already_sent
    after
      0 ->
        reason = Exception.normalize(kind, reason, stack)

        conn
        |> Plug.Conn.put_status(status(kind, reason))
        |> handle_errors.(%{kind: kind, reason: reason, stack: stack})
    end

    :erlang.raise(kind, reason, stack)
  end

  defp status(:error, error),  do: Plug.Exception.status(error)
  defp status(:throw, _throw), do: 500
  defp status(:exit, _exit),   do: 500
end
