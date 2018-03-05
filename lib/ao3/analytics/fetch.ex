defmodule Ao3.Analytics.Fetch do
  import Ecto.Query

  alias Ao3.Repo
  alias Ao3.Scraper
  alias Ao3.Analytics.Story
  alias Ao3.Analytics.User
  alias Ao3.Analytics.CreateOrUpdate

  @type story_type :: Story.story_type()

  @spec populate_bookmarkers_bookmarks(integer, story_type) :: :ok | any
  def populate_bookmarkers_bookmarks(story_id, story_type) do
    with story <- Repo.get_by(Story, story_id: story_id, type: story_type),
         story_data <- Scraper.fetch_story_data(story_id, story_type),
         {:ok, story} <- CreateOrUpdate.create_or_update_story_bookmarks(story, story_data),
         tags <- tag_names(story),
         usernames <- Scraper.fetch_story_bookmarkers(story_id, story_type),
         _ <- fetch_bookmarker_bookmarks(usernames, tags) do
      :ok
    else
      %Story{} -> :ok
      error -> error
    end
  end

  @spec fetch_bookmarker_bookmarks([String.t()], [String.t()]) :: [any]
  def fetch_bookmarker_bookmarks(usernames, tags) do
    usernames
    |> Task.async_stream(&fetch_one_bookmarkers_bookmarks(&1, tags), timeout: :infinity)
    |> Enum.to_list()
  end

  @spec fetch_one_bookmarkers_bookmarks(String.t(), [String.t()]) :: :ok | any
  defp fetch_one_bookmarkers_bookmarks(username, tags) do
    user = Repo.get(User, username)
    stories = Scraper.fetch_bookmarked_story_data(username, tags)
    {:ok, user} = CreateOrUpdate.create_or_update_user_bookmarks(user, username)
    delete_all_bookmark_joins(user.username)

    stories
    |> Enum.map(fn story_data ->
      story = create_or_update_story_data(story_data)
      %{username: user.username, story_id: story.id}
    end)
    |> insert_all_bookmark_joins()

    :ok
  end

  defp create_or_update_story_data(story_data) do
    %{story_id: story_id} = story_data
    story = Repo.get_by(Story, story_id: story_id)

    case CreateOrUpdate.create_or_update_story_data(story, story_data) do
      {:ok, story} -> story
    end
  end

  defp insert_all_bookmark_joins(data) do
    Repo.insert_all("bookmarks", data)
  end

  defp delete_all_bookmark_joins(username) do
    from(b in "bookmarks", where: b.username == ^username)
    |> Repo.delete_all()
  end

  @spec tag_names(Story.t()) :: [String.t()]
  defp tag_names(story) do
    [
      story.fandoms,
      story.ships
    ]
    |> Enum.concat()
  end
end
