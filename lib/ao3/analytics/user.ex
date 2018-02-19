defmodule Ao3.User do
  use Ecto.Schema

  alias __MODULE__

  @type t :: %User{
          id: integer,
          username: String.t()
        }

  schema "user" do
    field(:username)
  end

  @spec from_string(String.t()) :: t
  def from_string(username) do
    %User{username: username}
  end

  @spec to_id(t) :: String.t()
  def to_id(%User{username: username}) do
    username
  end
end