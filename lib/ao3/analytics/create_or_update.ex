defmodule Ao3.Analytics.CreateOrUpdate do
  alias Ao3.Repo
  alias Ao3.Scraper
  alias Ao3.Analytics.Story
  alias Ao3.Analytics.User
  alias Ao3.Analytics.Stale

  @spec create_or_update_user_bookmarks(User.t() | nil, String.t()) :: {:ok, User.t()}
  def create_or_update_user_bookmarks(user, username) do
    (user || %User{})
    |> User.bookmarks_changeset(%{username: username})
    |> Repo.insert_or_update()
  end

  @spec create_or_update_story_bookmarks(Story.t() | nil, Scraper.Story.t()) ::
          {:ok, Story.t()} | {:error, Ecto.Changeset.t()}
  def create_or_update_story_bookmarks(story, story_data) do
    (story || %Story{})
    |> Story.bookmarks_changeset(story_data)
    |> Repo.insert_or_update()
  end

  @spec create_or_update_story_data(Story.t() | nil, Scraper.Story.t()) :: {:ok, Story.t()}
  def create_or_update_story_data(story, story_data) do
    case story do
      nil ->
        create_story(story_data)

      story ->
        update_story(story, story_data)
    end
  end

  @spec update_story(Story.t(), Scraper.Story.t()) :: {:ok, Story.t()}
  defp update_story(story, story_data) do
    if Stale.stale?(story.updated_at) do
      story
      |> Story.changeset(story_data)
      |> Repo.update()
    else
      {:ok, story}
    end
  end

  defp create_story(story_data) do
    %Story{}
    |> Story.changeset(story_data)
    |> Repo.insert()
  end
end
