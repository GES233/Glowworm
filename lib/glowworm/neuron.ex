defmodule Glowworm.Neuron do
  @moduledoc """
  Neuron in `Glowworm` is a basic component.
  It is the building-block of the whole project.

  There are two phases in neurons:

  * activated
  * resting

  where a neuron at `resting` means that
  neuron doesn't in active, all status were
  blocked and no function invoked;
  when in `activated`, runners will work.
  """
  alias Glowworm.Neuron, as: N

  alias :gen_statem, as: GenStateM
  @behaviour GenStateM

  @type neuron_id :: pid() | atom()
  @type neuron_config :: N.Config.t()
  @type neuron_conn :: N.Conn.t()
  @type neuron_state :: :activate | :resting
  @type t :: %__MODULE__{
          config: Glowworm.Neuron.Config.t(),
          activate_runner: %{atom() => list(pid())},
          state: Glowworm.Neuron.State.t()
        }

  defstruct [:config, :activate_runner, :state]

  def start_link(args) do
    # TODO: Parse args.
    # Load config.
    # Set initial state.

    GenStateM.start_link(__MODULE__, args, [])
  end

  # Type of runners and params.

  def callback_mode(),
    # - :state_functions
    # - :handle_event_function
    do: :state_functions

  def init([]) do
    {:ok, :idle, ""}
  end

  def whoaimi(), do: self()
end

defmodule Glowworm.Neuron.Config do
  @moduledoc """
  Store params and runners.
  """

  @type model_name :: module() | atom()
  @type model_param :: struct() | map()
  @type model_conf :: %{:name => model_name(), :param => model_param()}
  @type syn_runner_conf :: map()
  # Glowworm.SomaRunner.conf()
  @type soma_runner_conf :: map()
  @type t :: %__MODULE__{
          synapse: %{atom() => {runner_conf(), model_conf()}},
          soma: {soma_runner_conf(), model_conf()}
        }
  defstruct [:synapse, :soma]
end

defmodule Glowworm.Neuron.State do
  @typedoc """
  Spike from soma(this or remote).
  """
  alias Glowworm.Neuron

  @type output_spike :: boolean()
  @type t :: %__MODULE__{
          counter: non_neg_integer(),
          input_spike: %{optional(Neuron.neuron_id()) => output_spike()} | [output_spike()] | nil,
          synaptic_current: %{optional(Neuron.neuron_id()) => number()} | [number()] | nil,
          membrane_potential: number() | nil,
          output_spike: output_spike() | nil
        }
  @state_properties [
    :counter,
    :input_spike,
    :synaptic_current,
    :membrane_potential,
    :output_spike
  ]
  defstruct [
    :counter,
    input_spike: nil,
    synaptic_current: nil,
    membrane_potential: nil,
    output_spike: nil
  ]

  ## Related to :input_spike.

  def all_fields_exists(state = %Glowworm.Neuron.State{}) do
    Map.from_struct(state)
    |> check_field_exist(nil, @state_properties)
  end

  defp check_field_exist(_state, result, []), do: result

  defp check_field_exist(state, _result, [_hd | rest] = field) when is_list(field) do
    _check_nil = fn x -> is_nil(x) end
    # ...

    check_field_exist(state, nil, rest)
  end

  def mix(_spike, _soma) do
    # ...
  end
end

defmodule Glowworm.Neuron.Conn do
  # Record connection.
  alias Glowworm.Neuron

  @type t :: %__MODULE__{
          from: list(Neuron.id()),
          to: list(Neuron.id())
        }
  defstruct [:from, :to]
end
