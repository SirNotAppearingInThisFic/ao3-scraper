require IEx

defmodule Ao3.Scraper.StoryPage do
  import Ao3.Scraper.HtmlParser

  alias Ao3.Scraper.Utils
  alias Ao3.Scraper.Story
  alias Ao3.Scraper.Tag

  @type response :: {:ok, Story.t()} | {:error, error}
  @type error :: :deleted | :unknown_type
  @type html :: Utils.html()

  @chapter_regex ~r/\d+\/(\d+)/

  @spec find_story_data(html) :: response
  def find_story_data(html) do
    html
    |> find_story_link()
    |> parse_story_data(html)
  end

  @spec parse_story_data({atom, html}, html) :: response
  defp parse_story_data({:deleted, _}, _), do: {:error, :deleted}
  defp parse_story_data({:unknown_type, _}, _), do: {:error, :unknown_type}

  defp parse_story_data({type, link_html}, html) do
    {:ok,
     %Story{
       story_id: link_html |> find_story_id(),
       author_name: html |> find_header_author() |> Floki.text(),
       type: type,
       name: link_html |> Floki.text(),
       tags: html |> find_tags(),
       story_date: html |> find_date(),
       word_count: int_dd(html, "words"),
       chapter_count: html |> find_dd("chapters") |> parse_chapters(),
       comment_count: int_dd(html, "comments"),
       kudos_count: int_dd(html, "kudos"),
       bookmark_count: int_dd(html, "bookmarks"),
       hit_count: int_dd(html, "hits")
     }}
  end

  @spec find_story_link(html) :: {Story.story_type(), html}
  defp find_story_link(html) do
    work_link = find_work_link(html)
    series_link = find_series_link(html)

    cond do
      !Enum.empty?(work_link) -> {:work, work_link}
      # Series
      !Enum.empty?(series_link) -> {:unknown_type, []}
      is_deleted?(html) -> {:deleted, []}
      true -> {:unknown_type, []}
    end
  end

  @spec find_story_id(html) :: integer
  defp find_story_id(html) do
    html
    |> Floki.attribute("href")
    |> List.first()
    |> story_id_of_story_url()
  end

  @spec story_id_of_story_url(String.t()) :: integer
  defp story_id_of_story_url(url) do
    url
    |> String.split("/")
    |> Enum.at(2)
    |> to_int()
  end

  @spec parse_chapters(String.t()) :: integer
  defp parse_chapters(text) do
    case Regex.run(@chapter_regex, text) do
      [_, chapters] -> to_int(chapters)
      _ -> 0
    end
  end

  defp find_header_author(html) do
    Floki.find(html, ".header .heading a[rel=\"author\"]")
  end

  defp find_work_link(html) do
    html
    |> Floki.find(".header .heading a[href*=\"/works/\"]")
  end

  defp find_series_link(html) do
    html
    |> Floki.find(".header .heading a[href*=\"/series/\"]")
  end

  @spec find_tags(html) :: [Tag.t()]
  defp find_tags(html) do
    [
      {".header .fandoms", :fandom},
      {".tags .warnings", :warning},
      {".tags .relationships", :ship},
      {".tags .characters", :character},
      {".tags .freeforms", :freeform}
    ]
    |> Enum.flat_map(fn {selector, tag} ->
      make_tags(html, "#{selector} .tag", tag)
    end)
  end

  @spec find_date(html) :: Timex.Types.valid_datetime()
  defp find_date(html) do
    case html
         |> Floki.find(".header .datetime")
         |> Floki.text()
         |> Timex.parse("{0D} {Mshort} {YYYY}") do
      {:ok, date} ->
        date

      {:error, _error} ->
        raise "can't parse story date"
    end
  end

  @spec is_deleted?(html) :: boolean
  defp is_deleted?(html) do
    html
    |> Floki.text()
    |> String.contains?("This has been deleted, sorry!")
  end

  @spec make_tags(html, String.t(), Tag.tag_type()) :: [Tag.t()]
  defp make_tags(html, selector, tag_type) do
    html
    |> Floki.find(selector)
    |> Enum.map(&Floki.text/1)
    |> Stream.map(&%Tag{type: tag_type, tag: &1})
    |> Enum.to_list()
  end
end
