defmodule Ao3.StoryId do
  alias __MODULE__
  alias Ao3.Id

  @type t :: %StoryId{
          id: Id.t()
        }

  defstruct [:id]

  @spec from_string(Id.t()) :: t
  def from_string(id) do
    %StoryId{id: id}
  end

  @spec to_id(t) :: Id.t()
  def to_id(%StoryId{id: id}) do
    id
  end
end