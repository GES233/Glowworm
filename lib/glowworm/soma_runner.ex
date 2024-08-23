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
          {atom(), model_param(), current_state(), soma_state(), R.t(),
           %{send: pid() | nil, inspect: pid() | nil}}

  def child_spec(_arg) do
    {}
  end

  @spec start_link(neuron_id(), conf(), init_state()) :: {:ok, pid()}
  def start_link(_neuron_id, conf, init),
    do: Agent.start_link(fn -> get_init_state(conf, init) end, name: __MODULE__)

  defp get_init_state(conf, init) do
    {conf[:model], conf[:param], init[:current], init[:soma], init[:runner], %{send: conf[:send], inspect: conf[:inspect]}}
  end

  # Simulation.

  def get_current() do
    receive do
      {:current, _value} -> nil
      # code
      _ -> nil
    end

    get_current()
  end

  # Wrap `Models.next_step/4`
  def do_single_step() do
    # ...
  end

  # Implemented runner prototype in `Demo`.
  # - continous calculate with recursion
  # - when counter = 0 =>
  #   do_some_stuff(send data to Neuron)
  # - when pulse =>
  #   do_some_stuff(send event to Neuron)

  ## Inspect

  def get_runner_state() do
    Agent.get(__MODULE__, fn {_, _, _, _, state} -> state end)
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
