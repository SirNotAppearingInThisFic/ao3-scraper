defmodule Ao3.Scraper.HtmlParser do
  alias Ao3.Scraper.Utils

  @type html :: Utils.html()

  @spec find_dd(html, String.t()) :: String.t()
  def find_dd(html, name) do
    html
    |> Floki.find("dd.#{name}")
    |> Floki.text()
  end

  @spec int_dd(html, String.t()) :: integer
  def int_dd(html, name) do
    html
    |> find_dd(name)
    |> to_int()
  end

  def to_int(""), do: 0

  def to_int(s) do
    {s, ""} = 
    s
    |> String.replace(",", "")
    |> Integer.parse()
    s
  end
end