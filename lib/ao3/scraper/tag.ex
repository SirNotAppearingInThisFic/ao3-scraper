defmodule Ao3.Scraper.Tag do
  alias __MODULE__

  @type tag_type :: :fandom | :warning | :ship | :character | :freeform

  @type t :: %Tag{
          type: tag_type,
          tag: String.t()
        }

  defstruct [type: :freeform, tag: ""]
end
