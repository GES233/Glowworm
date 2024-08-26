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
  alias :gen_statem, as: GenStateM
  # About gen_statem, see:
  # https://meraj-gearhead.ca/state-machine-in-elixir-using-erlangs-genstatem-behaviour

  @behaviour GenStateM

  @type state :: :idle | :running
  @type container :: {M.param(), M.state(), M.input(), R.RunnerState.t()}
  @type machine_state :: %{
          state: state(),
          container: container(),
          model: atom() | module(),
          conn: %{event: pid() | nil, inspect: pid() | nil}
        }

  ## Callbacks

  @impl GenStateM
  def callback_mode(), do: :state_functions

  def child_spec(opts) do
    {neuron_id, args} = opts

    %{
      id: neuron_id,
      start: {__MODULE__, :start_link, [args]}
    }
  end

  @spec init(any()) :: {:ok, machine_state()}
  @impl true
  def init(args) do
    conn = Keyword.validate!(args, event: :required, inspect: :optional)[:conn]
    model = Keyword.get(args, :model, Glowworm.Models.Izhikevich)

    {
      :ok,
      %{
        state: :idle,
        container: nil,
        model: model,
        conn: %{event: nil, inspect: nil | conn}
      }
    }
  end

  ## Handle events

  # :event

  # :update

  ## some inner functions.

  @spec do_next_step(machine_state()) :: machine_state()
  def do_next_step(state) do
    {next_state, next_runner_state} = apply(state[:model], :nextstep, state[:container])
    {param, _state, input, _runner_state} = state[:container]

    %{state | container: {param, next_state, input, next_runner_state}}
  end

  @spec do_update_current(machine_state(), any(), fun()) :: machine_state()
  def do_update_current(state, input, convert_func) do
    {param, state, _prev_input, runner_state} = state[:container]

    new_input = convert_func.(input)

    %{state | container: {param, state, new_input, runner_state}}
  end

  @spec do_update_runner_state(machine_state(), R.RunnerState.t()) :: machine_state()
  def do_update_runner_state(state, new_runner_state) do
    {param, state, input, _runner_state} = state[:container]

    %{state | container: {param, state, input, new_runner_state}}
  end

  # TODO: Add check halt spontaneously.
  # Invoked when counter in runner equals zero.
  @spec do_check_stable(machine_state()) :: machine_state()
  def do_check_stable(state) do
    {param, state, input, _runner_state} = state[:container]

    stable = apply(state[:model], :check_stable, [param, state, input])

    # TODO: Add send event.

    if(stable, do: %{state | state: :idle}, else: state)
  end

  # TODO: Ensure where is the neuron's id.
  def do_send_pulse(state) do
    {_param, _state, _input, runner_state} = state[:container]

    {:event, {:pulse, runner_state}}
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
