use Mix.Config

config :sugar,
  router: HexDepsChecker.Router

config :sugar, HexDepsChecker.Router,
  https_only: false,
  http: [port: System.get_env("PORT") || 4000],
  https: false

config :hex_deps_checker, HexDepsChecker.Repos.Main,
  database: "hex_deps_checker_main",
  username: "user",
  password: "pass",
  hostname: "localhost"
