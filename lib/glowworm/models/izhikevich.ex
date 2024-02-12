defmodule Glowworm.Models.Izhikevich do
  use Rustler,
    otp_app: :glowworm,
    crate: :izhikevich_model

  @behaviour Glowworm.Models
  alias Glowworm.Neuron.State, as: NeuronState
  alias Glowworm.SomaRunner.RunnerState
  alias Glowworm.Models.Izhikevich, as: M

  @spec nextstep(M.Param, M.NeuronState, M.InputState, RunnerState) ::
          {M.NeuronState, RunnerState}
  def nextstep(_param, _state, _input, _runner), do: :erlang.nif_error(:nif_not_loaded)

  def to_neuron(%M.NeuronState{} = neuron_status, %RunnerState{} = runner_status) do
    %NeuronState{membrane_potential: neuron_status.potential, output_spike: runner_status.event}
  end
end
