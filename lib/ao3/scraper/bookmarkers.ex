defmodule Ao3.Scraper.Bookmarkers do
  alias Ao3.Scraper.Utils
  alias Ao3.Scraper.Story
  alias Ao3.Scraper.StoryId
  alias Ao3.Scraper.StoryPage
  alias Ao3.Scraper.UserId
  alias Ao3.Scraper.Pagination
  alias Ao3.Scraper.Urls

  @type body :: Utils.html()

  @spec fetch_story_bookmarkers(StoryId.t()) :: [UserId.t()]
  def fetch_story_bookmarkers(story) do
    story
    |> Pagination.for_pages(&fetch_bookmarkers_page/2, &parse_bookmarkers_from_page/1)
    |> Enum.concat()
    |> Enum.uniq()
  end

  @spec fetch_story_data(StoryId.t()) :: Story.t()
  def fetch_story_data(story) do
    story
    |> fetch_bookmarkers_page("1")
    |> Floki.find(".work.blurb.group")
    |> StoryPage.find_story_data()
  end

  @spec fetch_bookmarkers_page(StoryId.t(), String.t()) :: body
  def fetch_bookmarkers_page(story = %StoryId{}, page) do
    story
    |> Urls.story_bookmarks(page)
    |> Utils.fetch_body()
  end

  @spec parse_bookmarkers_from_page(body) :: [UserId.t()]
  defp parse_bookmarkers_from_page(body) do
    body
    |> Floki.find(".user .byline a")
    |> Floki.attribute("href")
    |> Enum.map(&user_id_of_user_url/1)
  end

  defp user_id_of_user_url(url) do
    url
    |> String.split("/")
    |> Enum.at(2)
    |> UserId.from_string()
  end
end
