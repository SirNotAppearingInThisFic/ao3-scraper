defmodule Ao3.Analytics do
  alias Ao3.Repo
  alias Ao3.Scraper
  alias Ao3.Analytics.Story

  @spec populate_bookmarkers_bookmarks(integer) :: :ok
  def populate_bookmarkers_bookmarks(story_id) do
    with nil <- Repo.get(Story, story_id),
         story_data <- Scraper.fetch_story_data(story_id),
         story_changeset <- Story.changeset(%Story{}, story_data),
         {:ok, _story} <- Repo.insert(story_changeset),
         usernames <- Scraper.fetch_story_bookmarkers(story_id) do
      fetch_bookmarker_bookmarks(usernames)
      :ok
    else
      _ -> :ok
    end

    story_id
    |> Enum.filter()
    |> 
  end

  @spec fetch_bookmarker_bookmarks(String.t()) :: any
  def fetch_all_bookmarker_bookmarks(usernames) do
    usernames
    |> Task.async_stream()
  end

  def fetch_one_bookmarkers_bookmarks(username) do
    with nil <- Repo.get_by(User, username: username),
         user_changeset <- User.changeset(%User{}, %{username: username}),
         _user <- Repo.insert(user_changeset),
         stories <- Scraper.fetch_bookmarked_story_data(user),
         changesets <- Enum.map(&(Story.changeset(%Story{}, &1)))
         
    do
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