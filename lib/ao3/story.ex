defmodule Ao3.Story do
  alias __MODULE__
  alias Ao3.Id

  @type t :: %Story{
          url: String.t(),
          name: String.t(),
          author: Id.t(),
          fandoms: [String.t],
          tags: [String.t],
          words: integer,
          chapters: String.t(),
          comments: integer,
          kudos: integer,
          bookmarks: integer,
          hits: integer
        }

  defstruct [:url, :name, :author, :fandoms, :tags, :words, :chapters, :comments, :kudos, :bookmarks, :hits]
end