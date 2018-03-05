defmodule Mix.Tasks.Bookmarks do
  use Mix.Task

  alias Ao3.Analytics

  @shortdoc "Popualate bookmarks for a story"
  def run([story_id]) do
    Mix.Task.run("app.start", [])

    {story_id, ""} = Integer.parse(story_id)

    Analytics.populate(story_id)
  end
end
