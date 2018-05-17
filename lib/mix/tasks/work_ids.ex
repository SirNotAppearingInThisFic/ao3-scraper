defmodule Mix.Tasks.WorkIds do
  use Mix.Task

  alias Ao3.Scraper.StoryText
  alias Ao3.Scraper.UserId

  @shortdoc "Fetch ids for a user's stories"
  def run([username]) do
    Mix.Task.run("app.start", [])

    ids =
      username
      |> UserId.from_string()
      |> StoryText.fetch_work_ids()

    IO.puts("WORK COUNT: #{length(ids)}")

    File.write!("output/#{username}_work_ids.txt", ids |> Enum.join("\n"))
  end
end
