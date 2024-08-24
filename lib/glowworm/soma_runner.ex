defmodule Glowworm.SomaRunner do
  @moduledoc """
  SomaRunner.

  ### Events received

  * `{:activate, ...}` --> Initialize param, state, input, runner state
  * `{:freeze, ...}` --> Deactivate from outside
  * `{:event, ...}` --> Update Input
  * `{:update, ...}` --> Update RunnerState

  ### Events will send

  * `{:event, ...}` --> Send pulse
  * `{:state, ...}` --> Show state and runner state(used when inspect enabled)

  ### State

  * `:idle` --> do nothing until has stimulus or receive `:activate`.
  * `:running` --> Running simulation, receive stimulus until `:freeze` or stable.

  when in activation(not in `:idle`), the runner has
  periodic event during counter of runner state is zero.
  Usually adjust timestep or do anything else.
  """

  alias Glowworm.Models, as: M
  alias Glowworm.SomaRunner, as: R
  # alias :gen_statem, as: GenStateM
  # About gen_statem, see:
  # https://meraj-gearhead.ca/state-machine-in-elixir-using-erlangs-genstatem-behaviour

  # @behaviour GenStateM

  @type state :: :idle | :running
  @type container :: {M.param(), M.state(), M.input(), R.RunnerState.t()}
  @type machine_state :: %{
    state: state(),
    container: container(),
    model: atom() | module(),
    conn: %{event: pid() | nil, inspect: pid() | nil}
  }

  def child_spec(opts) do
    {neuron_id, args} = opts

    %{
      id: neuron_id,
      start: {__MODULE__, :start_link, [args]},
    }
  end
end

defmodule Glowworm.SomaRunner.RunnerState do
  @moduledoc """
  Only used for soma runner.
  """

  @type t :: %__MODULE__{
          event: atom(),
          counter: non_neg_integer(),
          timestep: number()
        }
  defstruct [:counter, :timestep, event: nil]
end
