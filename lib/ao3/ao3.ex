defmodule Ao3 do
  alias Ao3.StoryId
  alias Ao3.UserId

  @base_url "https://archiveofourown.org"

  @type html :: String.t() | Floki.html_tree()

  @type rated_story :: {StoryId.t(), integer}

  @page_re ~r/\?page=(\d+)/

  @spec get_bookmarks(String.t()) :: [rated_story]
  def get_bookmarks(user) do
    user
    |> UserId.from_string()
    |> fetch_bookmarked()
    |> Enum.take(1)
    |> fetch_and_concat(&fetch_all_bookmarkers/1)
    |> Enum.uniq()
    |> fetch_and_concat(&fetch_bookmarked/1)
    |> Enum.group_by(&identity/1)
    |> Enum.map(fn {user, users} ->
      {user, Enum.count(users)}
    end)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
    |> Enum.take(5)
  end

  @spec fetch_bookmarked(UserId.t()) :: [StoryId.t()]
  def fetch_bookmarked(%UserId{id: user}) do
    user
    |> user_bookmarks_url()
    |> fetch_body()
    |> Floki.find(".bookmark.blurb.group")
    |> find_story_ids()
  end

  @spec fetch_all_bookmarkers(StoryId.t()) :: [UserId.t()]
  @spec fetch_all_bookmarkers(StoryId.t(), String.t(), [[UserId.t()]]) :: [UserId.t()]
  def fetch_all_bookmarkers(story) do
    story
    |> fetch_all_bookmarkers("1", [])
  end

  def fetch_all_bookmarkers(story, page, acc) do
    case fetch_bookmarkers(story, page) do
      {:done, users} ->
        [users | acc]
        |> Enum.concat()

      {page, users} ->
        fetch_all_bookmarkers(story, page, [users | acc])
    end
  end

  @spec fetch_bookmarkers(StoryId.t(), String.t) :: {:done | String.t(), [UserId.t()]}
  def fetch_bookmarkers(%StoryId{id: story}, page) do
    body =
      story
      |> story_bookmarks_url(page)
      |> fetch_body()

    users =
      body
      |> Floki.find(".user .byline a")
      |> Floki.attribute("href")
      |> Enum.map(&user_id_of_user_url/1)

    next_page =
      case body
           |> Floki.find(".pagination .next a")
           |> List.first() do
        nil ->
          :done

        html ->
          html
          |> Floki.attribute("href")
          |> List.first()
          |> next_page_of_next_url()
      end

    {next_page, users}
  end

  @spec find_story_ids(html) :: [StoryId.t()]
  def find_story_ids(html) do
    html
    |> Floki.find(".header a[href*=\"/works/\"]")
    |> Floki.attribute("href")
    |> Enum.map(&story_id_of_story_url/1)
  end

  def user_id_of_user_url(url) do
    url
    |> String.split("/")
    |> Enum.at(2)
    |> UserId.from_string()
  end

  def story_id_of_story_url(url) do
    url
    |> String.split("/")
    |> Enum.at(2)
    |> StoryId.from_string()
  end

  def next_page_of_next_url(url) do
    [_, page_number] = Regex.run(@page_re, url)
    page_number
  end

  def fetch_body(url) do
    url
    |> HTTPoison.get!()
    |> Map.get(:body)
  end

  def user_bookmarks_url(user_id) do
    "#{@base_url}/users/#{user_id}/bookmarks"
  end

  def story_bookmarks_url(story_id, page) do
    "#{@base_url}/works/#{story_id}/bookmarks?page=#{page}"
  end

  def user_url(user_id) do
    "#{@base_url}/users/#{user_id}/pseuds/#{user_id}"
  end

  @spec fetch_and_concat(Enum.t(), any) :: [any]
  def fetch_and_concat(enum, f) do
    enum
    |> Task.async_stream(f)
    |> Enum.map(fn {:ok, data} -> data end)
    |> Enum.concat()
  end

  def identity(x), do: x
end