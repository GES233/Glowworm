defmodule Glowworm.Models do
  @moduledoc """
  Glowworm.Models implement the model in runner.
  This module records some common components.
  """
  alias Glowworm.SomaRunner, as: Soma
  alias Glowworm.SynapseRunner, as: Synapse

  @typedoc """
  State of model.
  """
  @type state :: map() | struct()

  @typedoc """
  Parameters of model.
  """
  @type param :: map() | struct()

  @typedoc """
  Extra singal or simulation of model.
  """
  @type input :: map() | struct() | atom()

  @typedoc """
  Runner state(implementation-agnostic).

  The meaning of use specific module is let
  the type of input and output coherence.
  """
  @type runner_state ::
          Soma.RunnerState.t()
          | Synapse.RunnerState.t()

  @doc """
  Calculate nextstep under model related paramater,
  model state, input(such as inject current or meterial)
  and runner status.

  * `param` - parameter of model
  * `state` - state of model
  * `input` - extra input(e.g. spike from other neuron or current from other
  component)
  * `runner_state` - something used for Runner that contain the model

  Tick0: (p, s0, i0, r0) => (s1, r1)
  Tick1: (p, s1, i1, r1) => (s2, r2)
  ...
  """
  @callback nextstep(param, state, input, runner_state) :: {state, runner_state}

  @doc """
  Send NeuronState under specific model into
  implement-agnostic format.

  Every part of runner didn't get entire state.
  """
  @callback to_neuron(state, runner_state) :: Glowworm.Neuron.State.t()

  # TODO: Add halt func
end
