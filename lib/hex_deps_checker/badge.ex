defmodule HexDepsChecker.Badge do
  @badge_base "https://img.shields.io/badge/"

  def url(code) do
    @badge_base <> name(code) <> ".svg"
  end

  defp name(code) do
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
