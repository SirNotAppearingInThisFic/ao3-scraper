defmodule Ao3.Analytics do
  @type story_type :: Story.story_type()

  alias Ao3.Analytics.Fetch

  @spec populate(integer, story_type) :: :ok | any
  defdelegate populate(story_id, story_type), to: Fetch, as: :populate_bookmarkers_bookmarks
end
