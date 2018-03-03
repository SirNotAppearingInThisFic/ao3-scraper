defmodule Ao3.Analytics.StaleTest do
  use ExUnit.Case

  alias Ao3.Analytics.Stale

  doctest Stale

  def date(date_string) do
    {:ok, now} = Timex.parse(date_string, "{YYYY}-{0M}-{0D}")
    now
  end

  describe "stale?" do
    setup do
      %{now: date("2018-01-01")}
    end

    test "detects stale dates", %{now: now} do
      test_date = date("2017-11-01")

      assert Stale.stale?(test_date, now) == true
    end

    test "detects fresh dates", %{now: now} do
      test_date = date("2017-12-31")

      assert Stale.stale?(test_date, now) == false
    end
  end
end
