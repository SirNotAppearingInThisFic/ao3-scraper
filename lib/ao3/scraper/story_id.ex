defmodule Ao3.Scraper.StoryId do
  alias __MODULE__

  @type t :: %StoryId{
          id: integer
        }

  defstruct [:id]

  @spec from_string(String.t) :: t
  def from_string(id) do
    {n, ""} = Integer.parse(id)
    from_int(n)
  end

  @spec from_int(integer) :: t
  def from_int(id) do
    %StoryId{id: id}
  end

  @spec to_id(t) :: integer
  def to_id(%StoryId{id: id}) do
    id
  end
end