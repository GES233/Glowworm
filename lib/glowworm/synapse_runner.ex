defmodule Glowworm.SynapseRunner do
  # alias :gen_statem, as: GenStateM
  alias Glowworm.Models, as: M
  alias Glowworm.SynapseRunner, as: S

  # @behaviour GenStateM

  @type state :: :idle | :running
  @type container :: {M.param(), M.state(), M.input(), S.RunnerState.t()}
  @type container_res :: {M.state(), S.RunnerState.t()}
  @type machine_state :: %{
          state: state(),
          container: container(),
          container_prev: container_res(),
          model: atom() | module(),
          conn: %{event: pid() | nil, inspect: pid() | nil}
        }

  ## Inner Functions

  @spec do_next_step(machine_state()) :: machine_state()
  def do_next_step(state) do
    {next_state, next_runner_state} = apply(state[:model], :nextstep, state[:container])
    {param, _state, input, _runner_state} = state[:container]

    %{state | container: {param, next_state, input, next_runner_state}}
  end

  @spec do_receive_pulse(machine_state(), any(), fun()) :: machine_state()
  def do_receive_pulse(state, input, convert_func) do
    {param, state, _prev_input, runner_state} = state[:container]

    %{state | container: {param, state, convert_func.(input), runner_state}}
  end

  @spec do_update_runner_state(machine_state(), S.RunnerState.t()) :: machine_state()
  def do_update_runner_state(state, new_runner_state) do
    {param, state, input, _runner_state} = state[:container]

    %{state | container: {param, state, input, new_runner_state}}
  end

  @spec do_check_stable(machine_state()) :: machine_state()
  def do_check_stable(state) do
    {_param, state1, input, _runner_state} = state[:container]
    {state2, _runner_state2} = state[:container_prev]

    stable = apply(state[:model], :check_stable, [state1, state2, input])

    # TODO: Add send event.
    # send(self(), {:halt, :model_in_stable})

    if(stable, do: %{state | state: :idle}, else: state)
  end

  # TODO: Add do_send_current/1.
end

defmodule Glowworm.SynapseRunner.RunnerState do
  @type t :: %__MODULE__{
          current: number(),
          counter: non_neg_integer(),
          timestep: number()
        }
  defstruct [:current, :counter, :timestep]
end
