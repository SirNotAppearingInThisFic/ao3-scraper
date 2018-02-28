defmodule Ao3.Scraper.Urls do
  @base "https://archiveofourown.org"

  @type t :: String.t()

  @spec user_bookmarks(String.t(), String.t()) :: t
  def user_bookmarks(user_id, page) do
    "#{@base}/users/#{user_id}/bookmarks?page=#{page}"
  end

  @spec story_bookmarks(integer, String.t()) :: t
  def story_bookmarks(story_id, page) do
    "#{@base}/works/#{story_id}/bookmarks?page=#{page}"
  end

  def story(story_id) do
    "#{@base}/works/#{story_id}"
  end

  def user(user_id) do
    "#{@base}/users/#{user_id}/pseuds/#{user_id}"
  end
end