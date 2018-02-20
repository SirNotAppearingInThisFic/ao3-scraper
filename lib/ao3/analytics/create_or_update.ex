defmodule Ao3.Analytics.CreateOrUpdate do
  alias Ao3.Repo
  alias Ao3.Scraper
  alias Ao3.Analytics.Story
  alias Ao3.Analytics.User
  alias Ao3.Analytics.Stale

  @spec create_or_update_user(User.t | nil, String.t) :: {:ok, User.t}
  def create_or_update_user(user, username) do
    case user do
      nil -> create_user(username)
      user -> {:ok, user}
    end
  end

  @spec create_or_update_story(Story.t() | nil, Scraper.Story.t()) ::
          {:ok, Story.t()} | {:error, Ecto.Changeset.t()}
  def create_or_update_story(story, story_data) do
    changeset =
      case story do
        nil ->
          create_story(story_data)
          story = update_story(story, story_data)
      end
  end

  defp update_story(story, story_data) do
    if Stale.stale?(story.updated_at) do
      story
      |> scraped_story_changeset(story_data)
      |> Repo.update()
    else
      {:ok, story}
    end
  end

  defp create_story(story_data) do
    %Story{}
    |> scraped_story_changeset(story_data)
    |> Repo.insert()
  end

  defp create_user(username) do
    %User{}
    |> User.changeset(%{username: username})
    |> Repo.insert()
  end

  defp scraped_story_changeset(story = %Story{}, story_data = %Scraper.Story{}) do
    story
    |> Story.changeset(story_data)
  end
end