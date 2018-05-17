defmodule Mix.Tasks.Text do
  use Mix.Task

  alias Ao3.Scraper.StoryText
  alias Ao3.Scraper.UserId

  @shortdoc "Fetch all text for a user's stories"
  def run([username]) do
    Mix.Task.run("app.start", [])

    ids =
      username
      |> UserId.from_string()
      |> StoryText.fetch_stories_text()

    IO.puts("WORK COUNT: #{length(ids)}")
    IO.inspect(ids)
  end
end
