defmodule Glowworm.Models.LIF.NeuroState do
  @type t :: %__MODULE__{
    potential: number(),
  }
  defstruct [:potential]
end

defmodule Glowworm.Models.LIF.InputState do
  @type t :: %__MODULE__{
    current: number(),
  }
  defstruct [:current]
end
