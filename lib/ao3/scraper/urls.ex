defmodule Ao3.Scraper.Urls do
  alias Ao3.Scraper.StoryId
  alias Ao3.Scraper.UserId

  @type t :: String.t()

  @base "https://archiveofourown.org"

  @spec user_bookmarks(UserId.t(), String.t()) :: t
  def user_bookmarks(%UserId{id: id}, page) do
    "#{@base}/users/#{id}/bookmarks?page=#{page}"
  end

  @spec story_bookmarks(StoryId.t(), String.t()) :: t
  def story_bookmarks(story_id = %StoryId{}, page) do
    "#{story(story_id)}/bookmarks?page=#{page}"
  end

  @spec story(StoryId.t()) :: t
  def story(%StoryId{id: id, type: type}) do
    "#{@base}/#{type}/#{id}"
  end

  def user(user_id) do
    "#{@base}/users/#{user_id}/pseuds/#{user_id}"
  end
end
