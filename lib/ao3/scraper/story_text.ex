defmodule Ao3.Scraper.StoryText do
  alias Ao3.Scraper.Utils
  alias Ao3.Scraper.StoryPage
  alias Ao3.Scraper.Story
  alias Ao3.Scraper.Urls
  alias Ao3.Scraper.UserId
  alias Ao3.Scraper.WorkId
  alias Ao3.Scraper.Pagination

  @type html :: Utils.html()

  @spec fetch_work_ids(UserId.t()) :: html()
  def fetch_work_ids(user) do
    user
    |> Pagination.for_pages(
      10,
      &fetch_works_page/2,
      &parse_story_metadata/1
    )
    |> Enum.concat()
  end

  @spec fetch_work_text(WorkId.t()) :: String.t()
  def fetch_work_text(work_id) do
    work_id
    |> fetch_work_page()
    |> parse_work()
  end

  @spec fetch_work_page(WorkId.t()) :: html
  defp fetch_work_page(work) do
    work
    |> Urls.work()
    |> Utils.fetch_body()
  end

  @spec fetch_works_page(UserId.t(), String.t()) :: html()
  defp fetch_works_page(user = %UserId{}, page) do
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

  defp parse_work(body) do
    body
    |> Floki.find("#chapters .userstuff")
    |> Floki.text()
  end
end
