defmodule Ao3.Analytics.StoryTest do
  use ExUnit.Case

  alias Ao3.Scraper
  alias Ao3.Analytics.User
  alias Ao3.Analytics.Story

  doctest Story

  test "changeset" do
    story_data = %Scraper.Story{
      id: 1,
      author_name: "SirNotAppearingInThisFic",
      name: "A Story",
      fandoms: ["Star Wars"],
      tags: ["Tag", "Tag2"],
      word_count: 1000,
      chapter_count: 1,
      comment_count: 50,
      kudos_count: 20,
      bookmark_count: 10,
      hit_count: 100
    }

    expected_story = %Story{
      id: 1,
      author_name: "SirNotAppearingInThisFic",
      name: "A Story",
      fandoms: ["Star Wars"],
      tags: ["Tag", "Tag2"],
      word_count: 1000,
      chapter_count: 1,
      comment_count: 50,
      kudos_count: 20,
      bookmark_count: 10,
      hit_count: 100
    }

    story =
      %Story{}
      |> Story.changeset(story_data)
      |> Ecto.Changeset.apply_changes()

    assert story == expected_story
  end
end