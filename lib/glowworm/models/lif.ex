defmodule Glowworm.Models.LIF do
  use Rustler,
    otp_app: :glowworm,
    crate: :lif_model

  @behaviour Glowworm.Models

  alias Glowworm.Neuron.State, as: NeuronState
  alias Glowworm.SomaRunner.RunnerState
  alias Glowworm.Models.LIF, as: M

  @impl true
  @spec nextstep(M.Param.t(), M.NeuronState.t(), M.InputState.t(), RunnerState.t()) ::
          {M.NeuronState.t(), RunnerState.t()}
  def nextstep(_param, _state, _input, _runner), do: :erlang.nif_error(:nif_not_loaded)
end
