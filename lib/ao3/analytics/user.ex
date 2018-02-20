defmodule Ao3.User do
  use Ecto.Schema

  alias __MODULE__

  alias Ecto.Changeset

  alias Ao3.Analytics.Story

  @type t :: %User{
          username: String.t(),
          bookmarks: [Story.t()],
          bookmarks_fetched_at: Timex.datetime()
        }

  @primary_key {:username, :string, []}
  @derive {Phoenix.Param, key: :username}
  @timestamps_opts [type: Timex.Ecto.DateTime]
  schema "user" do
    many_to_many(:bookmarks, Story, join_through: "bookmarks")

    field(:username)
    field(:bookmarks_fetched_at, Timex.Ecto.DateTime)
  end

  @spec changeset(t, %{username: String.t}) :: Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username])
    |> validate_required([:username])
    |> unique_constraint([:username])
  end

  @spec bookmarks_changeset(t, map) :: Changeset.t
  def bookmarks_changeset(struct, params) do
    struct
    |> changeset(params)
    |> put_change(:bookmarks_fetched_at, Ecto.DateTime.utc())
  end
end