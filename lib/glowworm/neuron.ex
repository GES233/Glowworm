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
  @type t :: %__MODULE__{
          counter: non_neg_integer(),
          input_spike: map() | list(),
          synaptic_current: number(),
          membrane_potential: number(),
          output_spike: boolean()
        }
  defstruct [:counter, :input_spike, :synaptic_current, :membrane_potential, :output_spike]
end
