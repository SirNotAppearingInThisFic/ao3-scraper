defmodule Ao3.Scraper.Story do
  alias __MODULE__

  @type t :: %Story{
    id: integer,
    author: UserId.t,
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

  defstruct [:id, :author, :name, :fandoms, :tags, :words, :chapters, :comments, :kudos, :bookmarks, :hits]
end