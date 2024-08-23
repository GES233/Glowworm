defmodule Glowworm.SomaRunner do
  @moduledoc """
  SomaRunner.

  * Running a frame(256 times)
    - zip the data to neuron.
  * Send event to `Neuron` if `pulse`
  * Adjust timestep
  """
  alias Glowworm.SomaRunner.RunnerState, as: R
  use Agent

  @type neuron_id :: atom()
  @type model_param :: map() | struct()
  @type soma_state :: map() | struct()
  @type current_state :: map() | struct() | number()

  # stable.
  @type conf :: %{
          param: model_param(),
          model: atom() | module(),
          # Send RunnerState to.
          send: pid() | nil,
          # Send soma's state to(usually used when inspect.)
          inspect: pid() | nil
        }
  # always update when running.
  @type init_state :: %{current: current_state(), soma: soma_state(), runner: R.t()}
  @type state ::
          {atom(), model_param(), soma_state(), current_state(), R.t(),
           %{send: pid() | nil, inspect: pid() | nil}}

  def child_spec(arg) do
    {neuron_id, conf, init} = arg

    %{
      id: neuron_id,
      start: {__MODULE__, :start_link, [neuron_id, conf, init]},
      type: :worker
    }
  end

  defp get_init_state(conf, init) do
    {conf[:model], conf[:param], init[:soma], init[:current], init[:runner],
     %{send: conf[:send], inspect: conf[:inspect]}}
  end

  @spec start_link(neuron_id(), conf(), init_state()) :: {:ok, pid()}
  def start_link(neuron_id, conf, init) do
    soma_name = String.to_atom("soma_#{neuron_id}")
    Agent.start_link(fn -> get_init_state(conf, init) end, name: soma_name)
  end

  # TODO: add id_to_pid

  # Simulation.

  def activate(_neuron_id), do: nil

  def deactivate(_neuron_id), do: nil

  def run() do
    # ?current.

    # Execute one step.

    # ?inspector

    # ?event
  end

  def stop(pid) do
    Agent.stop(pid)
  end

  def get_current() do
    receive do
      {:current, _value} -> nil
      # code
      _ -> nil
    end

    get_current()
  end

  @spec do_next_step(state()) :: {{soma_state(), R.t()}, state()}
  def do_next_step(state) do
    {model, param, soma, current, runner, conn} = state

    # Wrap `Models.next_step/4`
    {next_soma, next_runner} = apply(model, :nextstep, [param, soma, current, runner])

    %{
      res: {next_soma, next_runner},
      state: {model, param, next_soma, current, next_runner, conn}
    }
  end

  def do_single_step(pid) do
    Agent.get_and_update(pid, fn state ->
      {do_next_step(state)[:res], do_next_step(state)[:state]}
    end)
  end

  ## Inspect

  # todo: make private
  def do_inspect(state) do
    {_, _, _, soma, _, conn} = state

    # TODO: finish communicate spec.
    send(conn[:inspect], {:soma, soma})
  end

  def get_runner_state() do
    Agent.get(__MODULE__, fn {_, _, _, runner_state, _} -> runner_state end)
  end

  # send frame to Neuron.
end

defmodule Glowworm.SomaRunner.RunnerState do
  @moduledoc """
  Only used for soma runner.
  """

  # TODO: Add timestep here.
  @type t :: %__MODULE__{
          event: atom(),
          counter: non_neg_integer(),
          timestep: number()
        }
  defstruct [:counter, :timestep, event: nil]
end
