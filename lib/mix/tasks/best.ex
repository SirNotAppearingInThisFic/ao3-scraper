defmodule Mix.Tasks.Best do
  use Mix.Task

  alias Ao3.Analytics.User
  alias Ao3.Analytics
  alias Ao3.Scraper.Urls
  alias Ao3.Scraper.StoryId

  @shortdoc "Find the best stories for a story"
  def run([story_id]) do
    Mix.Task.run("app.start", [])

    {story_id, ""} = Integer.parse(story_id)

    story_id
    |> Analytics.best_story()
    |> Enum.map(fn %{story: story, rating: rating} ->
      %{rating: rating, name: story.name, bookmarks: story.bookmark_count, url: story_url(story)}
    end)
    |> IO.inspect()
  end

  defp story_url(story) do
    url = Urls.story(%StoryId{id: story.story_id, type: story.type})
    url <> "/bookmarks"
  end

  defp bookmarkers_to_names(bookmarkers) do
    bookmarkers
    |> Enum.map(fn %User{username: name} -> name end)
  end
end
