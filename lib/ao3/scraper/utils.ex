defmodule Ao3.Scraper.Utils do
  @type html :: String.t() | Floki.html_tree()

  @spec fetch_body(String.t()) :: Floki.html_tree()
  def fetch_body(url) do
    url
    |> HTTPoison.get!()
    |> Map.get(:body)
  end
end
