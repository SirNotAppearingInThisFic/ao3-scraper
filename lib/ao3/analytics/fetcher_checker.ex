defmodule Ao3.Analytics.FetcherChecker do
  alias Ao3.Analytics.Stale
  alias Ao3.Analytics.User
  alias Ao3.Analytics.Story

  @spec fetch_story_bookmarkers?(Story.t()) :: boolean
  def fetch_story_bookmarkers?(nil), do: true
  def fetch_story_bookmarkers?(%Story{bookmarks_fetched_at: nil}), do: true
  def fetch_story_bookmarkers?(%Story{bookmarks_fetched_at: date}) do
     Stale.stale?(date)
  end

  @spec fetch_user_bookmarks?(User.t()) :: boolean
  def fetch_user_bookmarks?(nil), do: true
  def fetch_user_bookmarks?(%User{bookmarks_fetched_at: date}) do
    Stale.stale?(date)
  end
end