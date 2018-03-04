require IEx

defmodule Ao3.Scraper.Urls do
  alias Ao3.Scraper.StoryId
  alias Ao3.Scraper.UserId
  alias Ao3.Scraper.Tag

  @type t :: String.t()

  @base "https://archiveofourown.org"

  @spec user_bookmarks(UserId.t(), [Tag.t], String.t()) :: t
  def user_bookmarks(%UserId{id: user_id}, tags, page) do
    query = %{
      "bookmark_search[query]" => tags_to_search(tags),
      "user_id" => user_id,
      "page" => page
    }

    "#{@base}/bookmarks?#{URI.encode_query(query)}"
  end

  @spec story_bookmarks(StoryId.t(), String.t()) :: t
  def story_bookmarks(story_id = %StoryId{}, page) do
    "#{story(story_id)}/bookmarks?page=#{page}"
  end

  @spec story(StoryId.t()) :: t
  def story(%StoryId{id: id, type: type}) do
    "#{@base}/#{pluralize(type)}/#{id}"
  end

  def user(user_id) do
    "#{@base}/users/#{user_id}/pseuds/#{user_id}"
  end

  defp pluralize(:work), do: "works"
  defp pluralize(:series), do: "series"

  @spec tags_to_search([Tag.t]) :: String.t
  defp tags_to_search(tags) do
    tags
    |> Enum.map(fn %Tag{tag: tag} -> "\"#{tag}\"" end)
    |> Enum.join("||")
  end
end
