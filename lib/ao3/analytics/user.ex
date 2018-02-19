defmodule Ao3.User do
  use Ecto.Schema

  alias __MODULE__

  alias Ecto.Changeset

  @type t :: %User{
          id: integer,
          username: String.t()
        }

  schema "user" do
    field(:username)
  end

  @spec changeset(t, %{username: String.t}) :: Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username])
    |> validate_required([:username])
    |> unique_constraint([:username])
  end
end