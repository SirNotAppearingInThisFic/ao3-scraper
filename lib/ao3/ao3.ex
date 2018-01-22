defmodule Ao3 do
  alias Ao3.StoryId
  alias Ao3.UserId
  alias Ao3.Story

  @base_url "https://archiveofourown.org"

  @type html :: String.t() | Floki.html_tree()

  @type rated_story :: {Story.t(), integer}

  @page_re ~r/\?page=(\d+)/

  @spec get_bookmarks(String.t()) :: [rated_story]
  def get_bookmarks(user) do
    user
    |> UserId.from_string()
    |> fetch_bookmarked_story_ids()
    |> Enum.take(1)
    |> fetch_and_concat(&fetch_all_bookmarkers/1)
    |> Enum.uniq()
    |> fetch_and_concat(&fetch_bookmarked_story_data/1)
    |> Enum.group_by(&Story.to_string/1)
    |> Enum.map(fn {_, stories} ->
      [story|_] = stories
      {story, Enum.count(stories)}
    end)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
    |> Enum.take(5)
  end

  @spec fetch_bookmarked_story_ids(UserId.t()) :: [StoryId.t()]
  def fetch_bookmarked_story_ids(user) do
    user
    |> fetch_bookmarked_html()
    |> find_story_ids()
  end

  @spec fetch_bookmarked_story_data(UserId.t) :: [Story.t]
  def fetch_bookmarked_story_data(user) do
    user
    |> fetch_bookmarked_html()
    |> Enum.map(&find_story_data/1)
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

  @spec fetch_bookmarkers(StoryId.t(), String.t()) :: {:done | String.t(), [UserId.t()]}
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

  @spec fetch_bookmarked_html(UserId.t()) :: [Floki.html_tree()]
  def fetch_bookmarked_html(%UserId{id: user}) do
    user
    |> user_bookmarks_url()
    |> fetch_body()
    |> Floki.find(".bookmark.blurb.group")
  end

  @spec find_story_ids(html) :: [StoryId.t()]
  def find_story_ids(html) do
    html
    |> find_header_title()
    |> Floki.attribute("href")
    |> Enum.map(&story_id_of_story_url/1)
  end

  @spec find_story_data(html) :: Story.t()
  def find_story_data(html) do
    %Story{
      id: find_story_ids(html) |> List.first(),
      name: html |> find_header_title() |> Floki.text(),
      author: html |> find_header_author() |> Floki.text(),
      fandoms: [],
      tags: [],
      words: find_dd(html, "words"),
      chapters: find_dd(html, "chapters"),
      comments: find_dd(html, "comments"),
      kudos: find_dd(html, "kudos"),
      bookmarks: find_dd(html, "bookmarks"),
      hits: find_dd(html, "hits")
    }
  end

  def find_dd(html, name) do
    html
    |> Floki.find("dd .#{name}")
    |> Floki.text()
  end

  def find_header_author(html) do
    Floki.find(html, ".header .heading a[rel=\"author\"]")
  end

  def find_header_title(html) do
    html
    |> Floki.find(".header .heading a[href*=\"/works/\"]")
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

  def story_url(story_id) do
    "#{@base_url}/works/#{story_id}"
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