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
  @type soma_model_state :: map() | struct()
  @type current_state :: map() | struct()

  @type conf %{init_current: current_state(), state_init: soma_model_state(), param: model_param()}

  @type state {model_param(), current_state(), soma_model_state(), R.t()}

  @spec start_link(neuron_id(), conf()) :: {:ok, pid()}
  def start_link(neuron_id, conf), do:
    Agent.start_link(fn -> state(conf) end, name: {__MODULE__, neuron_id})

  @spec init_state(conf()) :: state()
  def init_state(_conf) do
    # TODO:

    {}
  end

  # Simulation.

  def get_current() do
    receive do
      {:current, value} -> nil
        # code
      _ -> nil
    end
    get_current()
  end

  def get_neuron_state(), do: Agent.get()

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
