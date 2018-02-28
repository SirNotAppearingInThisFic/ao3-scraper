defmodule Ao3.Analytics do
  import Ecto.Query

  alias Ao3.Repo
  alias Ao3.Scraper
  alias Ao3.Analytics.Story
  alias Ao3.Analytics.User
  alias Ao3.Analytics.FetcherChecker
  alias Ao3.Analytics.CreateOrUpdate

  @spec populate_bookmarkers_bookmarks(integer) :: :ok
  def populate_bookmarkers_bookmarks(story_id) do
    with story <- Repo.get(Story, story_id),
         true <- FetcherChecker.fetch_story_bookmarkers?(story),
         story_data <- Scraper.fetch_story_data(story_id),
         _ <- IO.inspect(story_data),
         {:ok, _story} <- CreateOrUpdate.create_or_update_story_bookmarks(story, story_data),
         usernames <- Scraper.fetch_story_bookmarkers(story_id),
         _ <- fetch_bookmarker_bookmarks(usernames) do
      :ok
    else
      %Story{} -> :ok
      error -> error
    end
  end

  @spec fetch_bookmarker_bookmarks([String.t()]) :: any
  defp fetch_bookmarker_bookmarks(usernames) do
    usernames
    |> Task.async_stream(&fetch_one_bookmarkers_bookmarks/1)
  end

  @spec fetch_one_bookmarkers_bookmarks(String.t) :: any
  defp fetch_one_bookmarkers_bookmarks(username) do
    with user <- Repo.get(User, username),
         true <- FetcherChecker.fetch_user_bookmarks?(user),
         {:ok, _user} <- CreateOrUpdate.create_or_update_user_bookmarks(user, username),
         _ <- delete_all_bookmark_joins(username)
         do
      username
      |> Scraper.fetch_bookmarked_story_data()
      |> Enum.map(fn story_data ->
        story = create_or_update_story_data(story_data)
        %{username: username, story_id: story.id}
      end)
      |> insert_all_bookmark_joins()
      :ok
    else
      %User{} -> :ok
      error -> error
    end
  end

  defp create_or_update_story_data(story_data) do
    %{id: story_id} = story_data
    story = Repo.get(Story, story_id)
    {:ok, story} = CreateOrUpdate.create_or_update_story_data(story, story_data)
    story
  end

  defp insert_all_bookmark_joins(data) do
    Repo.insert_all(:bookmarks, data)
  end

  defp delete_all_bookmark_joins(username) do
    from(b in "bookmarks", where: b.username == ^username)
    |> Repo.delete_all()
  end
end