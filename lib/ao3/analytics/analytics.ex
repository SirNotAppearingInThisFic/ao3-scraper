defmodule Ao3.Analytics do
  import Ecto.Query

  alias Ao3.Repo
  alias Ao3.Analytics.Story
  alias Ao3.Analytics.Fetch

  @type story_type :: Story.story_type()

  @spec populate(integer) :: :ok | any
  defdelegate populate(story_id), to: Fetch, as: :populate_bookmarkers_bookmarks

  @spec best_story(integer) :: [%{story: Story.t(), rating: integer}]
  def best_story(story_id) do
    story_id
    |> Story.find(:work)
    |> best_query()
    |> Repo.all()
  end

  defp best_query(story) do
    from(
      s in Story,
      preload: [:bookmarkers],
      join: bs in subquery(rating_query(story)),
      on: [id: s.id],
      select: %{story: s, rating: bs.rating}
    )
  end

  defp rating_query(story) do
    from(
      b in "bookmarks",
      join: s in Story,
      on: b.story_id == s.id,
      join: bm in subquery(bookmarkers_query(story.id)),
      on: [username: b.username],
      where: fragment("? && ?", s.fandoms, ^story.fandoms),
      where: fragment("? && ?", s.ships, ^story.ships),
      group_by: b.story_id,
      where: s.id != ^story.id,
      select: %{id: b.story_id, rating: count(b.id)},
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
