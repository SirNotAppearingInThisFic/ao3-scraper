defmodule Mix.Tasks.User do
  use Mix.Task

  import Ecto.Query

  alias Ao3.Analytics
  alias Ao3.Repo

  @shortdoc "Popualate bookmarks for a user"
  def run([username]) do
    Mix.Task.run("app.start", [])

    Analytics.Fetch.fetch_bookmarker_bookmarks([username], [
      "Star Wars - All Media Types",
      "Star Wars Episode VII: The Force Awakens (2015)"
    ])

    Repo.all(
      from(
        b in "bookmarks",
        where: b.username == ^username,
        select: {b.id, b.story_id, b.username}
      )
    )
    |> IO.inspect()
  end
end