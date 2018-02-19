defmodule Ao3.Scraper.Bookmarked do
  alias Ao3.Scraper.Utils
  alias Ao3.Scraper.UserId
  alias Ao3.Scraper.StoryId
  alias Ao3.Scraper.Pagination
  alias Ao3.Scraper.Urls
  alias Ao3.Scraper.Story

  @type html :: Utils.html()

  @chapter_regex ~r/\d+\/(\d+)/

  @spec fetch_bookmarked_story_data(UserId.t()) :: [Story.t()]
  def fetch_bookmarked_story_data(user) do
    user
    |> Pagination.for_pages(&fetch_bookmarked_page/2, &parse_bookmarked_stories/1)
    |> Enum.concat()
  end

  @spec fetch_bookmarked_page(UserId.t(), String.t()) :: html()
  def fetch_bookmarked_page(%UserId{id: user}, page) do
    user
    |> Urls.user_bookmarks(page)
    |> Utils.fetch_body()
  end

  @spec parse_bookmarked_stories(html) :: [Story.t()]
  def parse_bookmarked_stories(body) do
    body
    |> Floki.find(".bookmark.blurb.group")
    |> Enum.map(&find_story_data/1)
  end

  @spec find_story_data(html) :: Story.t()
  def find_story_data(html) do
    %Story{
      id: find_story_ids(html) |> List.first(),
      name: html |> find_header_title() |> Floki.text(),
      author: html |> find_header_author() |> Floki.text(),
      fandoms: [],
      tags: [],
      words: int_dd(html, "words"),
      chapters: html |> find_dd("chapters") |> parse_chapters(),
      comments: int_dd(html, "comments"),
      kudos: int_dd(html, "kudos"),
      bookmarks: int_dd(html, "bookmarks"),
      hits: int_dd(html, "hits")
    }
  end

  @spec find_story_ids(html) :: [StoryId.t()]
  defp find_story_ids(html) do
    html
    |> find_header_title()
    |> Floki.attribute("href")
    |> Enum.map(&story_id_of_story_url/1)
  end

  @spec story_id_of_story_url(String.t()) :: StoryId.t()
  defp story_id_of_story_url(url) do
    url
    |> String.split("/")
    |> Enum.at(2)
    |> StoryId.from_string()
  end

  @spec find_dd(html, String.t()) :: String.t()
  defp find_dd(html, name) do
    html
    |> Floki.find("dd .#{name}")
    |> Floki.text()
  end

  @spec int_dd(html, String.t()) :: integer
  defp int_dd(html, name) do
    html
    |> find_dd(name)
    |> to_int()
  end

  defp parse_chapters(text) do
    @chapter_regex
    |> Regex.run(text)
    |> List.last()
    |> to_int()
  end

  defp find_header_author(html) do
    Floki.find(html, ".header .heading a[rel=\"author\"]")
  end

  defp find_header_title(html) do
    html
    |> Floki.find(".header .heading a[href*=\"/works/\"]")
  end

  defp to_int(""), do: 0

  defp to_int(s) do
    {s, ""} = Integer.parse(s)
    s
  end
end