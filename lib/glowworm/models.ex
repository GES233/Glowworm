defmodule Glowworm.Models do
  alias Glowworm.SomaRunner, as: Soma
  alias Glowworm.SynapseRunner, as: Synapse

  @typedoc """
  State of model.
  """
  @type state :: map() | struct()

  @typedoc """
  Parameter of model.
  """
  @type param :: map() | struct()

  @typedoc """
  Extra of model.
  """
  @type input :: map() | struct()

  @typedoc """
  Runner state(implementation-agnostic).
  """
  @type runner_state ::
          Soma.RunnerState.t()
          | Synapse.RunnerState.t()

  @doc """
  Calculate nextstep under model related paramater,
  model state, input(such as inject current or meterial)
  and runner status.
  """
  @callback nextstep(param, state, input, runner_state) :: {state, runner_state}

  @doc """
  Send NeuronState under specific model into
  implement-agnostic format.
  """
  @callback to_neuron(state) :: Glowworm.Neuron.State.t()
end
