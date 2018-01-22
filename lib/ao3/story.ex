defmodule Ao3.Story do
  alias __MODULE__
  alias Ao3.Id

  @type t :: %Story{
          id: String.t(),
          name: String.t(),
          author: Id.t(),
          fandoms: [String.t],
          tags: [String.t],
          words: String.t,
          chapters: String.t(),
          comments: String.t,
          kudos: String.t,
          bookmarks: String.t,
          hits: String.t
        }

  defstruct [:id, :name, :author, :fandoms, :tags, :words, :chapters, :comments, :kudos, :bookmarks, :hits]

  def to_string(%Story{id: id}) do
    id
  end
end