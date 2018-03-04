defmodule Ao3.Scraper.Story do
  alias __MODULE__

  @type story_type :: Ao3.Analytics.story_type()

  @type t :: %Story{
          story_id: integer,
          author_name: String.t(),
          type: story_type(),
          name: String.t(),
          fandoms: [String.t()],
          tags: [String.t()],
          word_count: integer,
          chapter_count: integer,
          comment_count: integer,
          kudos_count: integer,
          bookmark_count: integer,
          hit_count: integer,
          story_date: Timex.Types.valid_datetime() | nil,
        }

  defstruct [
    :story_id,
    :author_name,
    :type,
    :name,
    :fandoms,
    :tags,
    :story_date,
    :word_count,
    :chapter_count,
    :comment_count,
    :kudos_count,
    :bookmark_count,
    :hit_count
  ]
end
