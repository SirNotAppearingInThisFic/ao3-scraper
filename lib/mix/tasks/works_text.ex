defmodule Mix.Tasks.WorksText do
  use Mix.Task

  alias Ao3.Scraper.StoryText
  alias Ao3.Scraper.WorkId

  @shortdoc "Fetch ids for a user's stories"
  def run([username]) do
    Mix.Task.run("app.start", [])

    "output/#{username}_work_ids.txt"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&WorkId.from_string/1)
    |> Task.async_stream(&StoryText.fetch_work_text/1)
    |> Stream.map(fn {:ok, text} -> text <> "\n" end)
    |> Stream.into(File.stream!("output/#{username}_works.txt"))
    |> Stream.run()

    IO.puts("Done!")
  end
end
