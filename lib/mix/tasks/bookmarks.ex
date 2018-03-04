defmodule Mix.Tasks.Bookmarks do
  use Mix.Task

  alias Ao3.Analytics

  @shortdoc "Popualate bookmarks for a story"
  def run([story_id]), do: run([story_id, "work"])

  def run([story_id, type]) do
    Mix.Task.run "app.start", []

    story_type =
      case type do
        "work" -> :work
        "series" -> :series
        _ -> :work
      end

    Analytics.populate_bookmarkers_bookmarks(story_id, story_type)
  end
end