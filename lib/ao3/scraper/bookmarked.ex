defmodule Ao3.Scraper.Bookmarked do
  alias Ao3.Scraper.Utils
  alias Ao3.Scraper.UserId
  alias Ao3.Scraper.Pagination
  alias Ao3.Scraper.Urls
  alias Ao3.Scraper.Story
  alias Ao3.Scraper.StoryPage

  @type html :: Utils.html()

  @spec fetch_bookmarked_story_data(UserId.t()) :: [Story.t()]
  def fetch_bookmarked_story_data(user) do
    user
    |> Pagination.for_pages(&fetch_bookmarked_page/2, &parse_bookmarked_stories/1)
    |> Enum.concat()
  end

  @spec fetch_bookmarked_page(UserId.t(), String.t()) :: html()
  defp fetch_bookmarked_page(user = %UserId{}, page) do
    IO.puts("Fetching boomarks for: #{user.id}, page #{page}")

    user
    |> Urls.user_bookmarks(page)
    |> Utils.fetch_body()
  end

  @spec parse_bookmarked_stories(html) :: [Story.t()]
  defp parse_bookmarked_stories(body) do
    body
    |> Floki.find(".bookmark.blurb.group")
    |> Stream.map(&StoryPage.find_story_data/1)
    |> Stream.filter(fn
      {:ok, story} ->
        IO.puts("Fetched story: #{story.id}")
        true

      {:error, :unknown_type} ->
        IO.puts("UNKNOWN TYPE")
        false

      {:error, :deleted} ->
        IO.puts("DELETED STORY")
        false
    end)
    |> Enum.map(fn {:ok, story} -> story end)
  end
end
