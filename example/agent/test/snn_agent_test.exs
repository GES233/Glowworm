defmodule SNNAgentTest do
  use ExUnit.Case
  doctest SNNAgent

  test "greets the world" do
    assert SNNAgent.hello() == :world
  end
end
