defmodule Glowworm.Models.Izhikevich.NeuroState do
  @type t :: %__MODULE__{
    potential: number(),
    recovery: number(),
    current: number()
  }
  defstruct [:potential, :recovery, :current]
end
