defmodule Mix.Tasks.Best do
  use Mix.Task

  alias Ao3.Analytics

  @shortdoc "Find the best stories for a story"
  def run([story_id]) do
    Mix.Task.run("app.start", [])

    {story_id, ""} = Integer.parse(story_id)

    story_id
    |> Analytics.best_story()
    |> IO.inspect()
  end
end
