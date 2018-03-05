defmodule Ao3.Scraper.Pagination do
  @page_re ~r/[?&]page=(\d+)/

  @type page :: integer
  @type fetch_body :: (any, page -> Floki.html_tree())
  @type parse_data :: (Floki.html_tree() -> any)

  @spec for_pages(any, page, fetch_body, parse_data) :: [any]
  @spec for_pages(any, page, fetch_body, parse_data, page, [any]) :: [any]
  def for_pages(id, limit, fetch_body, parse_data) do
    for_pages(id, limit, fetch_body, parse_data, 1, [])
  end

  defp for_pages(id, limit, fetch_body, parse_data, page, acc) do
    body = fetch_body.(id, page)
    data = parse_data.(body)
    acc = [data | acc]

    case next_link(body, limit) do
      :done -> acc
      page -> for_pages(id, limit, fetch_body, parse_data, page, acc)
    end
  end

  @spec next_link(Floki.html_tree(), page) :: page | :done
  def next_link(body, limit) do
    case body
         |> Floki.find(".pagination .next a")
         |> List.first() do
      nil ->
        :done

      html ->
        html
        |> Floki.attribute("href")
        |> List.first()
        |> next_page_of_next_url(limit)
    end
  end

  @spec next_page_of_next_url(String.t(), page) :: page | :done
  def next_page_of_next_url(url, limit) do
    [_, page_number] = Regex.run(@page_re, url)

    case Integer.parse(page_number) do
      {n, ""} when n > limit -> :done
      {n, ""} -> n
    end
  end
end
