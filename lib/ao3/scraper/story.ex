defmodule Ao3.Scraper.Story do
  alias __MODULE__

  @type t :: %Story{
    id: integer,
    author_name: String.t,
    name: String.t,
    fandoms: [String.t],
    tags: [String.t],
    word_count: integer,
    chapter_count: integer,
    comment_count: integer,
    kudos_count: integer,
    bookmark_count: integer,
    hit_count: integer
  }

  defstruct [:id, :author_name, :name, :fandoms, :tags, :word_count, :chapter_count, :comment_count, :kudos_count, :bookmark_count, :hit_count]
end