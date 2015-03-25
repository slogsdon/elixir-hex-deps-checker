defmodule HexDepsChecker.Repos.Main do
  use Ecto.Repo,
    adapter: Ecto.Adapters.Postgres,
    otp_app: :hex_deps_checker
end
