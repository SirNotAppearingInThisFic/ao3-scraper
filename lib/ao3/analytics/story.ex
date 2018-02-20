defmodule Ao3.Analytics.Story do
  use Ecto.Schema

  alias __MODULE__

  alias Ecto.Changeset
  alias Ao3.Analytics.User
  alias Ao3.Scraper

  @type t :: %Story{
          id: integer,
          author_name: String.t,
          author: User.t(),
          bookmarkers: [User.t()],
          name: String.t(),
          fandoms: [String.t()],
          tags: [String.t()],
          word_count: integer,
          chapter_count: integer,
          comment_count: integer,
          kudos_count: integer,
          bookmark_count: integer,
          hit_count: integer,
          bookmarks_fetched_at: Timex.datetime()
        }

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}
  @timestamps_opts [type: Timex.Ecto.DateTime]
  schema "story" do
    belongs_to(:author, User, foreign_key: :author_name)

    many_to_many(:bookmarkers, User, join_through: "bookmarks")

    field(:tags, {:array, :string})
    field(:fandoms, {:array, :string})

    field(:name)
    field(:word_count, :integer)
    field(:chapter_count, :integer)
    field(:comment_count, :integer)
    field(:kudos_count, :integer)
    field(:bookmark_count, :integer)
    field(:hit_count, :integer)
    field(:bookmarks_fetched_at, Timex.Ecto.DateTime)
  end

  @spec changeset(t, Scraper.story()) :: Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :name, :words, :chapters, :comments, :kudos, :bookmarks, :hits])
  end
end