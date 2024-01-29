defmodule GlowwormTest do
  use ExUnit.Case
  doctest Glowworm

  test "greets the world" do
    assert Glowworm.hello() == :world
  end
end
