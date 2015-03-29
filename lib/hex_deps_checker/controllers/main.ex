defmodule HexDepsChecker.Controllers.Main do
  use Sugar.Controller
  alias HexDepsChecker.Badge

  def index(conn, _) do
    static conn, "index.html"
  end

  def image(conn, _args) do
    redirect conn, Badge.url(:ok)
  end
end
