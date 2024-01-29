defmodule Glowworn.Neuron do
  @moduledoc """
  #
  """

  @behaviour :gen_statem

  def callback_mode(), do: :state_functions

  def init([]) do
    {:ok, :idle, ""}
  end
end
