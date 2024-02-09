defmodule NeuronModelTest do
  @moduledoc """
  Test at model level.
  """
  use ExUnit.Case
  # doctest Glowworm.Models

  ## Izhikevich Model
  alias Glowworm.Models.Izhikevich, as: I

  defp izh_param() do
    %I.Param{peak_threshold: 30.0}
  end

  test "rest_potential" do
    {next_s, runner} = I.nextstep(
      izh_param(),
      %I.NeuronState{potential: -65.0, recovery: -9.2},
      %I.InputState{current: 0.0},
      %I.RunnerState{counter: 0}
    )

    assert %I.RunnerState{counter: 1, event: nil} == runner
  end

  test "action_potential" do
    {next_s, runner} = I.nextstep(
      izh_param(),
      %I.NeuronState{potential: 29.99, recovery: -15.0},  # IDK
      %I.InputState{current: 5.0},
      %I.RunnerState{counter: 0}
    )

    assert %I.RunnerState{counter: 1, event: :pulse} == runner
  end

  test "counter reset" do
    {next_s, runner} = I.nextstep(
      izh_param(),
      %I.NeuronState{potential: -65.0, recovery: -9.2},
      %I.InputState{current: 5.0},
      %I.RunnerState{counter: 255}
    )

    assert runner.counter == 0
  end

  ## LIF Model
  # ...

  ## TODO: Synapse modeling
  # ...
end
