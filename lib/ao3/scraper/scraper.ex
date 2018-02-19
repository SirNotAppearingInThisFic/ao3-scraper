defmodule Ao3.Scraper do
  alias Ao3.Scraper.Bookmarked
  alias Ao3.Scraper.Bookmarkers
  alias Ao3.Scraper.UserId
  alias Ao3.Scraper.Story

  @spec fetch_story_bookmarkers(StoryId.t()) :: [UserId.t()]
  defdelegate fetch_story_bookmarkers(story), to: Bookmarkers

  @spec fetch_bookmarked_story_data(UserId.t()) :: [Story.t()]
  defdelegate fetch_bookmarked_story_data(user), to: Bookmarked
end