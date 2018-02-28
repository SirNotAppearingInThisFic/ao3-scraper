defmodule Ao3.Scraper.UserId do
  alias __MODULE__

  @type t :: %UserId {
    id: String.t
  }

  defstruct [:id]

  @spec from_string(String.t) :: t
  def from_string(username) do
    %UserId{id: username}
  end

  @spec to_username(t) :: String.t()
  def to_username(%UserId{id: username}) do
    username
  end
end