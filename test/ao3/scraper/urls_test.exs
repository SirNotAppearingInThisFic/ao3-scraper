defmodule Ao3.Scraper.UrlsTest do
  use ExUnit.Case

  alias Ao3.Scraper.StoryId
  alias Ao3.Scraper.UserId
  alias Ao3.Scraper.Tag
  alias Ao3.Scraper.Urls

  doctest Urls

  test "user_bookmarks" do
    user = %UserId{id: "testname"}
    tags = [
      %Tag{type: :fandom, tag: "Star Wars"},
      %Tag{type: :ship, tag: "Finn/Poe"}
    ]

    query_key = URI.encode_www_form("bookmark_search[query]")
    query_value = URI.encode_www_form("\"Star Wars\"||\"Finn/Poe\"")
    expected_query = "#{query_key}=#{query_value}"

    assert Urls.user_bookmarks(user, tags, 1) ==
             "https://archiveofourown.org/bookmarks?#{expected_query}&page=1&user_id=testname"
  end

  test "story_bookmarks" do
    work = %StoryId{id: 1, type: :work}
    series = %StoryId{id: 2, type: :series}

    assert Urls.story_bookmarks(work, 1) == "https://archiveofourown.org/works/1/bookmarks?page=1"

    assert Urls.story_bookmarks(series, 3) ==
             "https://archiveofourown.org/series/2/bookmarks?page=3"
  end
end
