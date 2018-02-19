defmodule Ao3.Analytics.Story do
  use Ecto.Schema

  alias __MODULE__

  alias Ecto.Changeset
  alias Ao3.Analytics.User
  alias Ao3.Scraper

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

  @spec changeset(t, Scraper.story()) :: Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :name, :words, :chapters, :comments, :kudos, :bookmarks, :hits])
  end
end