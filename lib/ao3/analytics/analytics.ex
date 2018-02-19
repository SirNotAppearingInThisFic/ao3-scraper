defmodule Ao3.Analytics do
  def populate_bookmarkers_bookmarks() do

  end

  @spec fetch_and_concat(Enum.t(), any) :: [any]
  def fetch_and_concat(enum, f) do
    enum
    |> Task.async_stream(f)
    |> Enum.map(fn {:ok, data} -> data end)
    |> Enum.concat()
  end
end