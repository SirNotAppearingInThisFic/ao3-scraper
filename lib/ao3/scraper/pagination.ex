defmodule Ao3.Scraper.Pagination do
  @page_re ~r/\?page=(\d+)/

  @type page :: String.t()
  @type fetch_body :: (any, page -> Floki.html_tree())
  @type parse_data :: (Floki.html_tree() -> any)

  @spec for_pages(any, fetch_body, parse_data) :: [any]
  @spec for_pages(any, fetch_body, parse_data, page, [any]) :: [any]
  def for_pages(id, fetch_body, parse_data) do
    for_pages(id, fetch_body, parse_data, "1", [])
  end

  defp for_pages(id, fetch_body, parse_data, page, acc) do
    body = fetch_body.(id, page)
    data = parse_data.(body)
    acc = [data | acc]

    case next_link(body) do
      :done -> acc
      page -> for_pages(id, fetch_body, parse_data, page, acc)
    end
  end

  @spec next_link(Floki.html_tree()) :: page | :done
  def next_link(body) do
    case body
         |> Floki.find(".pagination .next a")
         |> List.first() do
      nil ->
        :done

      html ->
        html
        |> Floki.attribute("href")
        |> List.first()
        |> next_page_of_next_url()
    end
  end

  @spec next_page_of_next_url(String.t()) :: page
  def next_page_of_next_url(url) do
    [_, page_number] = Regex.run(@page_re, url)
    page_number
  end
end
