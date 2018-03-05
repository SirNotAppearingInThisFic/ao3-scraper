defmodule Mix.Tasks.Best do
  use Mix.Task

  alias Ao3.Analytics.User
  alias Ao3.Analytics

  @shortdoc "Find the best stories for a story"
  def run([story_id]) do
    Mix.Task.run("app.start", [])

    {story_id, ""} = Integer.parse(story_id)

    story_id
    |> Analytics.best_story()
    |> Enum.map(fn %{story: story, count: count} ->
      {count, story.name, story.story_id, bookmarkers_to_names(story.bookmarkers)}
    end)
    |> IO.inspect()
  end

  defp bookmarkers_to_names(bookmarkers) do
    bookmarkers
    |> Enum.map(fn %User{username: name} -> name end)
  end
end
