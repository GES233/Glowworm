defmodule Glowworm.Models.Izhikevich do
  use Rustler,
    otp_app: :glowworm,
    crate: :izhikevich_model

  @behaviour Glowworm.Models

  alias Glowworm.Neuron.State, as: NeuronState
  alias Glowworm.SomaRunner.RunnerState
  alias Glowworm.Models.Izhikevich, as: M

  @impl true
  @spec nextstep(M.Param.t(), M.NeuronState.t(), M.InputState.t(), RunnerState.t()) ::
          {M.NeuronState.t(), RunnerState.t()}
  def nextstep(_param, _state, _input, _runner), do: :erlang.nif_error(:nif_not_loaded)

  @impl true
  def to_neuron(%M.NeuronState{} = neuron_status, %RunnerState{} = runner_status) do
    %NeuronState{
      counter: runner_status.counter,
      membrane_potential: neuron_status.potential,
      output_spike: runner_status.event
    }
  end
end
