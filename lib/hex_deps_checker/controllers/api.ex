defmodule HexDepsChecker.Controllers.Api do
  use Sugar.Controller
  use HexDepsChecker.ErrorHandler

  defmodule UnknownSCMHostError do
    defexception message: "Unknown SCM host"
  end

  def lock(conn, loc: loc, org: org, repo: repo) do
    url = get_url(loc, org, repo)
    r = url |> HTTPoison.get!
    eval_opts = [requires: [],
                 macros: [],
                 aliases: [],
                 functions: []]
    json = r.body
      |> Code.eval_string([], eval_opts)
      |> elem(0)
      |> Enum.map(fn {dep, {:hex, dep, version}} ->
        %{} |> Map.put(dep, Hex.has_update?(dep, version))
      end)
      |> Poison.encode!
    raw conn |> resp(200, json)
  end

  defp get_url(loc, org, repo) do
    case loc do
      "github"    -> "https://raw.githubusercontent.com/#{org}/#{repo}/master/mix.lock"
      "bitbucket" -> "https://bitbucket.org/#{org}/#{repo}/raw/master/mix.lock"
      _           -> raise UnknownSCMHostError
    end
  end

  defp handle_errors(conn, assigns) do
    json conn, %{error: assigns.reason}
  end
end

