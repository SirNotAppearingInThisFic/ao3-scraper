defmodule Ao3.Analytics.Stale do
  use Timex

  @stale_days Timex.Duration.from_days(7)

  @spec stale?(Timex.Types.valid_datetime()) :: boolean
  def stale?(date) do
    stale?(date, Timex.today())
  end

  def stale?(date, compare_date) do
    Timex.before?(date, stale_date(compare_date))
  end

  defp stale_date(date) do
    Timex.subtract(date, @stale_days)
  end
end
