defmodule HexDepsChecker.Hex do
  @headers [{"User-Agent", "HexDepsChecker (0.0.1) - slogsdon"}]

  def has_update?(dep, version) do
    latest = HTTPoison.get!("https://hex.pm/api/packages/#{dep}", @headers)
      |> Map.get(:body)
      |> Poison.decode!
      |> Map.get("releases")
      |> hd

    Version.compare(latest["version"], version) == :gt
  end

  def get_raw(package) do
    HTTPoison.get!("https://hex.pm/api/packages/#{package}", @headers)
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
end
