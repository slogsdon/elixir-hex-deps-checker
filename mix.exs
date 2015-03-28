defmodule HexDepsChecker.Mixfile do
  use Mix.Project

  def project do
    [app: :hex_deps_checker,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps,
     test_coverage: [tool: ExCoveralls]]
  end

  def application do
    [applications: [:logger, :sugar,
                    :poison, :httpoison],
     mod: {HexDepsChecker, []}]
  end

  defp deps do
    [{:sugar, "~> 0.4.4"},
     {:poison, "~> 1.3.1"},
     {:httpoison, "~> 0.6"},
     {:excoveralls, "~> 0.3.8", only: :test},
     {:dialyze, "~> 0.1.4", only: :test}]
  end
end
