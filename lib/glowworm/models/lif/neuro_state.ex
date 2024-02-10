defmodule Glowworm.Models.LIF.NeuronState do
  @type t :: %__MODULE__{
    potential: number(),
    fire: boolean(),
    # Why `fire`?
    # Because of its name: Leaky-Integrate-**Fire**!
  }
  defstruct [:potential, :fire]
end

defmodule Glowworm.Models.LIF.InputState do
  @type t :: %__MODULE__{
    current: number(),
  }
  defstruct [:current]
end
