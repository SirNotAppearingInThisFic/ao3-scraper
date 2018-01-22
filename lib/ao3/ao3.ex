defmodule Ao3 do
  alias Ao3.StoryId
  alias Ao3.UserId

  @base_url "https://archiveofourown.org"

  @type html :: String.t() | Floki.html_tree()

  @type rated_story :: {StoryId.t(), integer}

  @spec get_bookmarks(String.t()) :: [rated_story]
  def get_bookmarks(user) do
    user
    |> UserId.from_string()
    |> fetch_bookmarked()
    |> fetch_and_concat(&fetch_bookmarkers/1)
    |> Enum.uniq()
    |> fetch_and_concat(&fetch_bookmarked/1)
    |> Enum.group_by(&identity/1)
    |> Enum.map(&Enum.count/1)
  end

  @spec fetch_bookmarked(UserId.t()) :: [StoryId.t()]
  def fetch_bookmarked(%UserId{id: user}) do
    user
    |> user_bookmarks_url()
    |> fetch_body()
    |> Floki.find(".bookmark.blurb.group")
    |> find_story_ids()
  end

  @spec fetch_bookmarkers(StoryId.t()) :: [UserId.t()]
  def fetch_bookmarkers(%StoryId{id: story}) do
    story
    |> story_bookmarks_url()
    |> fetch_body()
    |> Floki.find(".user .byline a")
    |> Floki.attribute("href")
    |> Enum.map(&user_id_of_user_url/1)
  end

  @spec find_story_ids(html) :: [StoryId.t()]
  def find_story_ids(html) do
    html
    |> Floki.find(".header a[href*=\"/works/\"]")
    |> Floki.attribute("href")
    |> Enum.map(&story_id_of_story_url/1)
  end

  defp user_id_of_user_url(url) do
    url
    |> String.split("/")
    |> Enum.at(2)
    |> UserId.from_string()
  end

  defp story_id_of_story_url(url) do
    url
    |> String.split("/")
    |> Enum.at(2)
    |> StoryId.from_string()
  end

  defp fetch_body(url) do
    url
    |> HTTPoison.get!()
    |> Map.get(:body)
  end

  defp user_bookmarks_url(user_id) do
    "#{@base_url}/users/#{user_id}/bookmarks"
  end

  defp story_bookmarks_url(story_id) do
    "#{@base_url}/works/#{story_id}/bookmarks"
  end

  defp user_url(user_id) do
    "#{@base_url}/users/#{user_id}/pseuds/#{user_id}"
  end

  @spec fetch_and_concat(Enum.t(), any) :: [any]
  defp fetch_and_concat(enum, f) do
    enum
    |> Task.async_stream(f)
    |> Enum.map(fn {:ok, data} -> data end)
    |> Enum.concat()
  end

  defp identity(x), do: x
end