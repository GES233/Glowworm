defmodule Glowworm.Models.LIF do
  use Rustler,
    otp_app: :glowworm,
    crate: :lif_model

  @behaviour Glowworm.Models

  # alias Glowworm.Neuron.State, as: NeuronState
  alias Glowworm.SomaRunner.RunnerState
  alias Glowworm.Models.LIF, as: M

  @impl true
  @spec nextstep(M.Param.t(), M.NeuronState.t(), M.InputState.t(), RunnerState.t()) ::
          {M.NeuronState.t(), RunnerState.t()}
  def nextstep(_param, _state, _input, _runner), do: :erlang.nif_error(:nif_not_loaded)

  @impl true
  @spec check_stable(M.NeuronState.t(), M.NeuronState.t(), M.InputState.t()) :: boolean
  def check_stable(%M.NeuronState{potential: p1}, %M.NeuronState{potential: p2}, %M.InputState{current: 0.0}) do
    - 0.0001 < (p1 - p2) and (p1 - p2) < +0.0001
  end
  def check_stable(_state1, _state2, _input), do: false
end
