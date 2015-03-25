defmodule HexDepsChecker do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(HexDepsChecker.Repos.Main, [])
    ]

    opts = [strategy: :one_for_one, name: HexDepsChecker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
