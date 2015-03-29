use Mix.Config

config :sugar,
  router: HexDepsChecker.Router,
  show_debugger: true

config :sugar, HexDepsChecker.Router,
  https_only: false,
  http: [port: System.get_env("PORT") || 4000],
  https: false

config :hex_deps_checker, HexDepsChecker.Repos.Main,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"}
