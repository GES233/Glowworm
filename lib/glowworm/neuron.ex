defmodule Glowworn.Neuron do
  @moduledoc """
  #
  """
  alias :gen_statem, as: GenStateM
  @behaviour GenStateM

  def start_link(args), do:
    GenStateM.start_link(__MODULE__, args, [])

  def callback_mode(),
    # - :state_functions
    # - :handle_event_function
    do: :state_functions

  def init([]) do
    {:ok, :idle, ""}
  end
end
