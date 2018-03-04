defmodule Ao3.Analytics.Story do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  @type story_type :: :work | :status

  alias Ao3.Repo
  alias Ecto.Changeset
  alias Ao3.Analytics.StoryTypeEnum
  alias Ao3.Analytics.User
  alias Ao3.Scraper

  @type t :: %Story{
          id: integer | nil,
          story_id: integer | nil,
          type: story_type,
          author_name: String.t() | nil,
          author: User.t() | not_loaded,
          bookmarkers: [User.t()] | not_loaded,
          name: String.t(),
          fandoms: [String.t()],
          tags: [String.t()],
          word_count: integer,
          chapter_count: integer,
          comment_count: integer,
          kudos_count: integer,
          bookmark_count: integer,
          hit_count: integer,
          bookmarks_fetched_at: Timex.Types.valid_datetime() | nil,
          story_date: Timex.Types.valid_datetime() | nil,
          inserted_at: Timex.Types.valid_datetime() | nil,
          updated_at: Timex.Types.valid_datetime() | nil
        }

  @typep not_loaded :: %Ecto.Association.NotLoaded{}

  schema "stories" do
    belongs_to(:author, User, foreign_key: :author_name, references: :username, type: :string)

    many_to_many(
      :bookmarkers,
      Story,
      join_through: "bookmarks",
      join_keys: [story_id: :id, username: :username]
    )

    field(:story_id, :integer)
    field(:type, StoryTypeEnum, default: :work)

    field(:tags, {:array, :string}, default: [])
    field(:fandoms, {:array, :string}, default: [])

    field(:name, :string, default: "")
    field(:word_count, :integer, default: 0)
    field(:chapter_count, :integer, default: 0)
    field(:comment_count, :integer, default: 0)
    field(:kudos_count, :integer, default: 0)
    field(:bookmark_count, :integer, default: 0)
    field(:hit_count, :integer, default: 0)
    field(:bookmarks_fetched_at, Timex.Ecto.DateTime)
    field(:story_date, Timex.Ecto.DateTime)

    timestamps()
  end

  @spec changeset(t, Scraper.story()) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params |> Map.from_struct(), [
      :story_id,
      :type,
      :author_name,
      :name,
      :tags,
      :fandoms,
      :story_date,
      :word_count,
      :chapter_count,
      :comment_count,
      :kudos_count,
      :bookmark_count,
      :hit_count
    ])
  end

  @spec bookmarks_changeset(t, Scraper.story()) :: Changeset.t()
  def bookmarks_changeset(struct, params) do
    struct
    |> changeset(params)
    |> put_change(:bookmarks_fetched_at, Timex.now())
  end


  def find(story_id, story_type) do
    Repo.get_by(Story, story_id: story_id, type: story_type)
  end
end
