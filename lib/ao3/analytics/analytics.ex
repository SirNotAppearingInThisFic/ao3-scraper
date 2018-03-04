defmodule Ao3.Analytics do
  import Ecto.Query

  alias Ao3.Repo
  alias Ao3.Analytics.Story
  alias Ao3.Analytics.Fetch

  @type story_type :: Story.story_type()

  @spec populate(integer, story_type) :: :ok | any
  defdelegate populate(story_id, story_type), to: Fetch, as: :populate_bookmarkers_bookmarks

  @spec best_story(integer, story_type) :: [Story.t()]
  def best_story(story_id, story_type) do
    story = Story.find(story_id, story_type)

    story.id
    |> best_query()
    |> Repo.all()
  end

  defp best_query(story_id) do
    from(
      s in Story,
      join: bs in subquery(bookmarked_query(story_id)),
      on: [id: s.id],
      select: %{story: s, count: bs.count}
    )
  end

  defp bookmarked_query(story_id) do
    from(
      b in "bookmarks",
      join: bm in subquery(bookmarkers_query(story_id)),
      on: [username: b.username],
      group_by: b.story_id,
      select: %{id: b.story_id, count: count(b.id)},
      order_by: [desc: :count],
      limit: 10
    )
  end

  defp bookmarkers_query(story_id) do
      from(
        b in "bookmarks",
        where: b.story_id == ^story_id,
        select: %{username: b.username}
      )
  end
end
