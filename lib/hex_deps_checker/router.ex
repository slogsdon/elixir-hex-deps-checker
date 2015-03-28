defmodule HexDepsChecker.Router do
  use Sugar.Router
  plug Sugar.Plugs.HotCodeReload

  if Sugar.Config.get(:sugar, :show_debugger, false) do
    plug Plug.Debugger, otp_app: :hex_deps_checker
  end

  plug Plug.Static, at: "/static", from: :hex_deps_checker

  # Uncomment the following line for session store
  # plug Plug.Session, store: :ets, key: "sid", secure: true, table: :session

  # Define your routes here
  get "/", HexDepsChecker.Controllers.Main, :index
  get "/image", HexDepsChecker.Controller.Main, :image
  get "/:loc/:org/:repo", HexDepsChecker.Controllers.Main, :lock
end
