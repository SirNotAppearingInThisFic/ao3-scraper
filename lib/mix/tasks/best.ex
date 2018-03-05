defmodule Mix.Tasks.Best do
  use Mix.Task

  alias Ao3.Analytics

  @shortdoc "Find the best stories for a story"
  def run([story_id]), do: run([story_id, "work"])

  def run([story_id, type]) do
    Mix.Task.run("app.start", [])

    {story_id, ""} = Integer.parse(story_id)

    story_type =
      case type do
        "work" -> :work
        "series" -> :series
        _ -> :work
      end

    story_id
    |> Analytics.best_story(story_type)
    |> IO.inspect()
  end
end
