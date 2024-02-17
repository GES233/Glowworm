defmodule Glowworm.Models.AlphaSynapse do
  @moduledoc false

  @behaviour Glowworm.Models

  def nextstep(_param, _state, _input, _runner_state), do: :erlang.nif_error(:nif_not_loaded)

  def nextstep(param, state, input, runner_state, _opts \\ []) do
    # TODO: update opts parsing
    nextstep(param, state, input, runner_state)
  end

  def to_neuron(_state, _runner_state) do
  end
end
