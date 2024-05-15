defmodule Glowworm.Neuron do
  @moduledoc """
  #
  """
  alias :gen_statem, as: GenStateM
  @behaviour GenStateM

  def start_link(args), do: GenStateM.start_link(__MODULE__, args, [])

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
          synaptic_current: %{optional(atom() | pid()) => number()} | [number()] | number(),
          membrane_potential: number(),
          output_spike: output_spike()
        }
  @state_properties [:counter, :input_spike, :synaptic_current, :membrane_potential, :output_spike]
  defstruct [:counter, :input_spike, :synaptic_current, :membrane_potential, :output_spike]

  ## Related to :input_spike.

  def all_fields_exists(state = %State{}) do
    Map.from_struct(state)
    |> check_field_exist(nil, @state_properties)
  end

  defp check_field_exist(_state, result, []), do: result
  defp check_field_exist(state, result, field) when is_list(field) do
    check_nil = fn x -> is_nil(x) end
    # ...
  end

  def mix(spike, soma) do
    # ...
  end
end
