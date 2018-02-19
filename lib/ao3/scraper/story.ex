defmodule Ao3.Scraper.Story do
  alias __MODULE__

  @type t :: %Story{
    id: integer,
    author: UserId.t,
    name: String.t,
    fandoms: [String.t],
    tags: [String.t],
    words: integer,
    chapters: integer,
    comments: integer,
    kudos: integer,
    bookmarks: integer,
    hits: integer
  }

  defstruct [:id, :author, :name, :fandoms, :tags, :words, :chapters, :comments, :kudos, :bookmarks, :hits]
end