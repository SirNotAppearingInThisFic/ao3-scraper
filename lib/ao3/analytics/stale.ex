defmodule Ao3.Analytics.Stale do
  use Timex

  @stale_days 7

  @spec stale?(Timex.Types.datetime()) :: boolean
  def stale?(date) do
    Timex.before?(date, stale_date())
  end

  defp stale_date() do
    Timex.shift(Timex.today(), days: @stale_days)
  end
end