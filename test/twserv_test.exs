defmodule TwservTest do
  use ExUnit.Case
  doctest Twserv

  test "greets the world" do
    assert Twserv.hello() == :world
  end
end
