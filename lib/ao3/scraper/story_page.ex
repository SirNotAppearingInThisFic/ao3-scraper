require IEx

defmodule Ao3.Scraper.StoryPage do
  import Ao3.Scraper.HtmlParser

  alias Ao3.Scraper.Utils
  alias Ao3.Scraper.Story

  @type html :: Utils.html()

  @chapter_regex ~r/\d+\/(\d+)/

  @spec find_story_data(html) :: Story.t()
  def find_story_data(html) do
    %Story{
      id: find_story_id(html),
      author_name: html |> find_header_author() |> Floki.text(),
      name: html |> find_header_title() |> Floki.text(),
      fandoms: [],
      tags: [],
      word_count: int_dd(html, "words"),
      chapter_count: html |> find_dd("chapters") |> parse_chapters(),
      comment_count: int_dd(html, "comments"),
      kudos_count: int_dd(html, "kudos"),
      bookmark_count: int_dd(html, "bookmarks"),
      hit_count: int_dd(html, "hits")
    }
  end

  @spec find_story_id(html) :: integer
  defp find_story_id(html) do
    html
    |> find_header_title()
    |> Floki.attribute("href")
    |> List.first()
    |> story_id_of_story_url()
  end

  @spec story_id_of_story_url(String.t()) :: integer
  def story_id_of_story_url(url) do
    url
    |> String.split("/")
    |> Enum.at(2)
    |> to_int()
  end

  @spec parse_chapters(String.t()) :: integer
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
end