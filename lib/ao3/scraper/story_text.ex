defmodule Ao3.Scraper.StoryText do
  alias Ao3.Scraper.Utils
  alias Ao3.Scraper.StoryPage
  alias Ao3.Scraper.Story
  alias Ao3.Scraper.Urls
  alias Ao3.Scraper.UserId
  alias Ao3.Scraper.WorkId
  alias Ao3.Scraper.Pagination

  @type html :: Utils.html()

  @spec fetch_stories_text(UserId.t()) :: html()
  def fetch_stories_text(user) do
    user
    |> Pagination.for_pages(
      10,
      &fetch_works_page/2,
      &parse_story_metadata/1
    )
    |> Stream.concat()
    |> Stream.map(fn %Story{story_id: story_id} ->
      WorkId.from_int(story_id)
    end)
    |> Stream.map(&fetch_work/1)
    |> Enum.to_list()
  end

  defp fetch_work(%WorkId{id: work_id}) do
    work_id
  end

  @spec fetch_works_page(UserId.t(), String.t()) :: html()
  defp fetch_works_page(user = %UserId{}, page) do
    IO.puts("Fetching story metadata for: #{user.id}, page #{page}")

    user
    |> Urls.user_works(page)
    |> Utils.fetch_body()
  end

  @spec parse_story_metadata(html) :: [Story.t()]
  defp parse_story_metadata(body) do
    body
    |> Floki.find(".work.blurb.group")
    |> Stream.map(&StoryPage.find_story_data/1)
    |> Stream.filter(fn
      {:ok, story} ->
        IO.puts("Fetched story: #{story.story_id}")
        true

      {:error, :unknown_type} ->
        IO.puts("UNKNOWN TYPE")
        false

      {:error, :deleted} ->
        IO.puts("DELETED STORY")
        false
    end)
    |> Enum.map(fn {:ok, story} -> story end)
  end
end
