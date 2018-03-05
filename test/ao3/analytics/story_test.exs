defmodule Ao3.Analytics.StoryTest do
  use ExUnit.Case

  alias Ao3.Scraper
  alias Ao3.Analytics.Story

  doctest Story

  test "changeset" do
    date = {2018, 1, 1}
    ecto_date = Timex.to_datetime(date)

    story_data = %Scraper.Story{
      story_id: 123,
      author_name: "SirNotAppearingInThisFic",
      name: "A Story",
      type: :work,
      tags: [
        %Scraper.Tag{type: :fandom, tag: "Star Wars"},
        %Scraper.Tag{type: :ship, tag: "Poe/Finn"},
        %Scraper.Tag{type: :character, tag: "Poe"},
        %Scraper.Tag{type: :character, tag: "Finn"},
        %Scraper.Tag{type: :warning, tag: "Too Cool 4 School"},
        %Scraper.Tag{type: :freeform, tag: "Tag1"},
        %Scraper.Tag{type: :freeform, tag: "Tag2"}
      ],
      story_date: date,
      word_count: 1000,
      chapter_count: 1,
      comment_count: 50,
      kudos_count: 20,
      bookmark_count: 10,
      hit_count: 100
    }

    expected_story = %Story{
      story_id: 123,
      author_name: "SirNotAppearingInThisFic",
      name: "A Story",
      fandoms: ["Star Wars"],
      ships: ["Poe/Finn"],
      characters: ["Poe", "Finn"],
      warnings: ["Too Cool 4 School"],
      tags: ["Tag1", "Tag2"],
      story_date: ecto_date,
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
