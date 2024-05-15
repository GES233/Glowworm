defmodule Glowworm.Models.AlphaSynapse do
  @moduledoc """
  `AlphaSynapse` means synapses that post-synaptic membrane
  activations in alpha function(functions like ...).
  """
  alias Glowworm.Neuron.State, as: NeuronState

  @behaviour Glowworm.Models

  # Pulse
  # =(alpha func)=>   g(Conductance)
  # =(I = g(V - E))=> I(Current) // NMDA required
  # Shunting inhibition
  def nextstep(_param, _state, _input, _runner_state), do: :erlang.nif_error(:nif_not_loaded)

  def to_neuron(_state, _runner_state) do
    %NeuronState{}
  end
end
