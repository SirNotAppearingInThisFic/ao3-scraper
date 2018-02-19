defmodule Ao3.Story do
  alias __MODULE__
  alias Ao3.Id

  alias Ao3.User

  use Ecto.Schema

  @type t :: %Story{
          id: integer | nil,
          author_id: integer,
          author: User.t(),
          bookmarkers: [User.t()],
          name: String.t(),
          fandoms: [String.t()],
          tags: [String.t()],
          words: integer,
          chapters: integer,
          comments: integer,
          kudos: integer,
          bookmarks: integer,
          hits: integer
        }

  schema "story" do
    belongs_to(:author, User)

    many_to_many(:bookmarkers, User, join_through: "bookmarks")

    field(:tags, {:array, :string})
    field(:fandoms, {:array, :string})

    field(:name)
    field(:words, :integer)
    field(:chapters, :integer)
    field(:comments, :integer)
    field(:kudos, :integer)
    field(:bookmarks, :integer)
    field(:hits, :integer)
  end

  def to_string(%Story{id: id}) do
    id
  end

  @spec from_string(Id.t()) :: t
  def from_string(id) do
    %Story{id: id}
  end

  @spec to_id(t) :: Id.t()
  def to_id(%Story{id: id}) do
    id
  end
end