defmodule ModelTest.IzhikevichTest do
  use ExUnit.Case

  alias Glowworm.Models.Izhikevich, as: I

  defmodule ElixirIzhikevich do
    @moduledoc """
    Izhikevich model writtern in pure elixir.
    """

    # @behaviour Glowworm.Models

    def dv(v, u, i), do: 0.04 * v * v + 5.0 * v + 140.0 - u + i
    def du(v, u, a, b), do: a * (b * v - u)
    def update(v, u, c, d, peak) when v >= peak, do: {c, u + d}
    def update(v, u, _c, _d, _peak), do: {v, u}

    def nextstep(
          %I.Param{a: a, b: b, c: c, d: d, peak_threshold: peak},
          %I.NeuronState{potential: v, recovery: u},
          %I.InputState{current: inject_current},
          runner = %Glowworm.Runners.Soma.RunnerState{}
        ) do
      dv = dv(v, u, inject_current)
      du = du(v, u, a, b)
      # Use Eular
      next_v = v + runner.timestep * dv
      next_u = u + runner.timestep * du

      event =
        cond do
          next_v >= peak -> :pulse
          _ -> nil
        end

      {v, u} = update(next_u, next_u, c, d, peak)

      {%I.NeuronState{potential: v, recovery: u},
       %{runner | counter: runner.counter + 1, event: event}}
    end

    def check_stable(_state1, _state2, _input) do
      false
    end
  end

  describe "single next step test" do
    setup %{} do
      # ...
    end

    test "" do
      # ...
    end
  end
end
