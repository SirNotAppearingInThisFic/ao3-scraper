defmodule Ao3.UserId do
  alias __MODULE__
  alias Ao3.Id

  @type t :: %UserId {
    id: Id.t
  }

  defstruct [:id]

  @spec from_string(Id.t) :: t
  def from_string(id) do
    %UserId{id: id}
  end

  @spec to_id(t) :: Id.t()
  def to_id(%UserId{id: id}) do
    id
  end
end