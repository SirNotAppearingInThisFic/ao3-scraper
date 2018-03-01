defmodule Ao3.Analytics.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  alias Ecto.Changeset

  alias Ao3.Analytics.Story

  @type t :: %User{
          username: String.t() | nil,
          bookmarks: [Story.t()] | not_loaded,
          bookmarks_fetched_at: Timex.Types.datetime() | nil
        }

  @typep not_loaded :: %Ecto.Association.NotLoaded{}

  @primary_key {:username, :string, []}
  schema "users" do
    many_to_many(
      :bookmarks,
      Story,
      join_through: "bookmarks",
      join_keys: [username: :username, story_id: :id]
    )

    field(:bookmarks_fetched_at, Timex.Ecto.DateTime)

    timestamps()
  end

  @spec changeset(t, map) :: Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username])
    |> validate_required([:username])
  end

  @spec bookmarks_changeset(t, map) :: Changeset.t()
  def bookmarks_changeset(struct, params) do
    struct
    |> changeset(params)
    |> put_change(:bookmarks_fetched_at, Ecto.DateTime.utc())
  end
end