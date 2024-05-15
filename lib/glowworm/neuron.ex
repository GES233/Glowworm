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
  when in `activated`, .
  """
  alias :gen_statem, as: GenStateM
  @behaviour GenStateM

  def start_link(args), do: GenStateM.start_link(__MODULE__, args, [])
  # Type of runners and params.

  def callback_mode(),
    # - :state_functions
    # - :handle_event_function
    do: :state_functions

  def init([]) do
    {:ok, :idle, ""}
  end
end

defmodule Glowworm.Neuron.State do
  @typedoc """
  Spike from soma(this or remote).
  """

  @type output_spike :: boolean()
  @type t :: %__MODULE__{
          counter: non_neg_integer(),
          input_spike: %{optional(atom() | pid()) => output_spike()} | [output_spike()] | nil,
          synaptic_current: %{optional(atom() | pid()) => number()} | [number()] | nil,
          membrane_potential: number() | nil,
          output_spike: output_spike() | nil
        }
  @state_properties [:counter, :input_spike, :synaptic_current, :membrane_potential, :output_spike]
  defstruct [:counter, input_spike: nil, synaptic_current: nil, membrane_potential: nil, output_spike: nil]

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
