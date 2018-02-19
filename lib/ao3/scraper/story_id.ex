defmodule Ao3.Scraper.StoryId do
  alias __MODULE__
  alias Ao3.Scraper.Id

  @type t :: %StoryId{
          id: Id.t()
        }

  defstruct [:id]

  @spec from_string(Id.t()) :: t
  def from_string(id) do
    {n, ""} = Integer.parse(id)
    %StoryId{id: n}
  end

  @spec to_id(t) :: Id.t()
  def to_id(%StoryId{id: id}) do
    id
  end
end