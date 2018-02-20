defmodule Ao3.Analytics do
  alias Ao3.Repo
  alias Ao3.Scraper
  alias Ao3.Analytics.Story
  alias Ao3.Analytics.FetcherChecker
  alias Ao3.Analytics.CreateOrUpdate

  @spec populate_bookmarkers_bookmarks(integer) :: :ok
  def populate_bookmarkers_bookmarks(story_id) do
    with true <- FetcherChecker.fetch_story_bookmarkers?(story_id),
         story <- Repo.get(Story, story_id),
         story_data <- Scraper.fetch_story_data(story_id),
         # TODO: Send a bookmarked_at param
         {:ok, _story} <- CreateOrUpdate.create_or_update_story(story, story_data),
         usernames <- Scraper.fetch_story_bookmarkers(story_id) do
      fetch_bookmarker_bookmarks(usernames)
      :ok
    else
      _ -> :ok
    end
  end

  @spec fetch_bookmarker_bookmarks([String.t()]) :: any
  def fetch_bookmarker_bookmarks(usernames) do
    usernames
    |> Task.async_stream(&fetch_one_bookmarkers_bookmarks/1)
  end

  def fetch_one_bookmarkers_bookmarks(username) do
    with user <- Repo.get(User, username),
         true <- FetcherChecker.fetch_user_bookmarks?(user),
         # TODO: Send a bookmarked_at param
         {:ok, user} <- CreateOrUpdate.create_or_update_user(user, username),
         all_story_data <- Scraper.fetch_bookmarked_story_data(user),
         _stories <-
           Enum.map(all_story_data, fn story_data ->
             %{id: story_id} = story_data
             story = Repo.get(Story, story_id)
             CreateOrUpdate.create_or_update_story(story, story_data)
           end) do
        # TODO: delete all join table rows for user
        # TODO: insert_all join table rows for user/stories
      :ok
    else
      _ ->
        :ok
    end
  end

  @spec fetch_and_concat(Enum.t(), any) :: [any]
  def fetch_and_concat(enum, f) do
    enum
    |> Task.async_stream(f)
    |> Enum.map(fn {:ok, data} -> data end)
    |> Enum.concat()
  end
end