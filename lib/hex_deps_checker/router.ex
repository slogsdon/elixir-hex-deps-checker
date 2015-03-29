defmodule HexDepsChecker.Router do
  use Sugar.Router
  use HexDepsChecker.ErrorHandler
  alias HexDepsChecker.Controllers.Main
  alias HexDepsChecker.Controllers.Api

  plug Plug.Static, at: "/", from: :hex_deps_checker

  # Main routes
  get "/",      Main, :index
  get "/image", Main, :image

  # Api routes
  get "/api/:loc/:org/:repo", Api, :lock
end
