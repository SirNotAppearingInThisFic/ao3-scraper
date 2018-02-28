defmodule Ao3.Scraper do
  alias Ao3.Scraper.Bookmarked
  alias Ao3.Scraper.Bookmarkers
  alias Ao3.Scraper.UserId
  alias Ao3.Scraper.Story
  alias Ao3.Scraper.StoryId

  @type user_id :: UserId.t()
  @type story_id :: StoryId.t()
  @type story :: Story.t()

  @spec fetch_story_bookmarkers(integer) :: [String.t()]
  def fetch_story_bookmarkers(story) do
    story
    |> StoryId.from_int()
    |> Bookmarkers.fetch_story_bookmarkers()
    |> Enum.map(&UserId.to_username/1)
  end

  @spec fetch_bookmarked_story_data(String.t) :: [Story.t()]
  def fetch_bookmarked_story_data(username) do
    username
    |> UserId.from_string()
    |> Bookmarked.fetch_bookmarked_story_data()
  end

  @spec fetch_story_data(integer) :: Story.t()
  def fetch_story_data(story) do
    story
    |> StoryId.from_int()
    |> Bookmarkers.fetch_story_data()
  end
end