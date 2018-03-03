defmodule Ao3.Scraper.StoryId do
  alias __MODULE__

  @type story_type :: Ao3.Analytics.story_type()

  @type t :: %StoryId{
          id: integer,
          type: story_type
        }

  defstruct [:id, :type]

  @spec from_string(String.t(), story_type) :: t
  def from_string(id, type) do
    {n, ""} = Integer.parse(id)
    from_int(n, type)
  end

  @spec from_int(integer, story_type) :: t
  def from_int(id, type) do
    %StoryId{id: id, type: type}
  end
end
