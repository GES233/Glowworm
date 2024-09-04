defmodule Glowworm.Models.Izhikevich do
  use Rustler,
    otp_app: :glowworm,
    crate: :izhikevich_model

  @behaviour Glowworm.Models

  # alias Glowworm.Neuron.State, as: NeuronState
  alias Glowworm.SomaRunner.RunnerState
  alias Glowworm.Models.Izhikevich, as: M

  @impl true
  @spec nextstep(M.Param.t(), M.NeuronState.t(), M.InputState.t(), RunnerState.t()) ::
          {M.NeuronState.t(), RunnerState.t()}
  def nextstep(_param, _state, _input, _runner), do: :erlang.nif_error(:nif_not_loaded)

  @impl true
  def check_stable(
        %M.NeuronState{recovery: _u1, potential: _v1},
        %M.NeuronState{recovery: _u2, potential: _v2},
        %M.InputState{current: +0.0}
      ) do
    false
    # TODO: impl it.
  end

  def check_stable(
        %M.NeuronState{recovery: _u1, potential: _v1},
        %M.NeuronState{recovery: _u2, potential: _v2},
        %M.InputState{current: -0.0}
      ) do
    false
    # TODO: impl it.
  end

  def check_stable(_state1, _state2, _input), do: nil
end
