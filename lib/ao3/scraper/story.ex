defmodule Ao3.Scraper.Story do
  alias __MODULE__

  alias Ao3.Scraper.Tag

  @type story_type :: Ao3.Analytics.story_type()

  @type t :: %Story{
          story_id: integer,
          author_name: String.t(),
          type: story_type(),
          name: String.t(),
          tags: [Tag.t()],
          word_count: integer,
          chapter_count: integer,
          comment_count: integer,
          kudos_count: integer,
          bookmark_count: integer,
          hit_count: integer,
          story_date: Timex.Types.valid_datetime() | nil
        }

  defstruct story_id: nil,
            author_name: "",
            type: :work,
            name: "",
            tags: [],
            story_date: nil,
            word_count: 0,
            chapter_count: 0,
            comment_count: 0,
            kudos_count: 0,
            bookmark_count: 0,
            hit_count: 0
end
