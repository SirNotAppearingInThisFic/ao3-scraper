defmodule Ao3.Scraper.HtmlParserTest do
  use ExUnit.Case

  alias Ao3.Scraper.HtmlParser

  doctest Ao3.Scraper.HtmlParser


  test "find_dd" do
    html = """
      <dl>
        <dd class="nope">Nope</dd>
        <dd class="yep">Yep</dd>
      </dl>
    """
    assert HtmlParser.find_dd(html, "yep") == "Yep"
  end

  test "int_dd" do
    html = """
      <dl>
        <dd class="nope">Nope</dd>
        <dd class="yep">15</dd>
      </dl>
    """
    assert HtmlParser.int_dd(html, "yep") == 15
  end

  test "to_int" do
    assert HtmlParser.to_int("") == 0
    assert HtmlParser.to_int("13") == 13
    assert HtmlParser.to_int("1,321") == 1321
  end
end