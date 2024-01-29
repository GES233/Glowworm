defmodule Glowworm.Port do
  use GenServer

  def init(_init_arg) do
    {:ok, :state_normal}
  end

  # def handle_call
  # def ternimate
end
