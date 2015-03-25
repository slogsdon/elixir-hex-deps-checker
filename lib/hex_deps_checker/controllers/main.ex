defmodule HexDepsChecker.Controllers.Main do
  use Sugar.Controller

  defmodule UnknownHostError do
    defexception message: "Unknown SCM host"
  end

  @badge_base "https://img.shields.io/badge/"

  def index(conn, []) do
    render conn
  end

  def lock(conn, loc: loc, org: org, repo: repo) do
    url = case loc do
        "github"    -> "https://raw.githubusercontent.com/#{org}/#{repo}/master/mix.lock"
        "bitbucket" -> "https://bitbucket.org/#{org}/#{repo}/raw/master/mix.lock"
        _           -> raise UnknownHostError
    end

    r = url |> HTTPoison.get!
    eval_opts = [requires: [],
                 macros: [],
                 aliases: [],
                 functions: []]
    r.body
    |> Code.eval_string([], eval_opts)
    |> IO.inspect
    raw conn |> resp(200, r.body)
  end

  def image(conn, _args) do
    name = get_name(:ok)
    conn
      |> put_resp_header("Location", @badge_base <> "#{name}.svg")
      |> send_resp(302, "Found")
  end

  def get_name(code) do
    status = statuses[code]
    msg = status.msg
      |> String.replace("_", "__")
      |> String.replace("-", "--")
      |> String.replace(" ", "_")
    ["dependencies",
     msg,
     status.color]
      |> Enum.join("-")
  end

  def get_raw(package) do
    HTTPoison.get!("https://hex.pm/api/packages/#{package}")
      |> Map.get(:body)
      |> Poison.decode!
      |> Map.get("releases")
      |> hd
      |> Map.get("url")
      |> HTTPoison.get!
      |> Map.get(:body)
      |> Poison.decode!
      |> Map.get("requirements")
  end

  defp statuses do
    [
      ok:        %{color: "green",
                   msg:   "up to date"},
      available: %{color: "yellow",
                   msg:   "update(s) available"},
      unknown:   %{color: "lightgrey",
                   msg:   "unknown"}
    ]
  end
end
