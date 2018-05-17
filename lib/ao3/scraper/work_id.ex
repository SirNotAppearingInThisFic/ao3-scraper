defmodule Ao3.Scraper.WorkId do
  alias __MODULE__

  @type t :: %WorkId{ id: integer }

  defstruct [:id]

  @spec from_string(String.t()) :: t
  def from_string(id) do
    {n, ""} = Integer.parse(id)
    from_int(n)
  end

  @spec from_int(integer) :: t
  def from_int(id) do
    %WorkId{id: id}
  end
end
