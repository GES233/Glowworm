defmodule Glowworm.Models.Izhikevich.NeuronState do
  @type t :: %__MODULE__{
    potential: number(),
    recovery: number(),
  }
  defstruct [:potential, :recovery]
end

defmodule Glowworm.Models.Izhikevich.InputState do
  @type t :: %__MODULE__{
    current: number(),
    counter: integer(),
  }
  defstruct [:current, :counter]
end

defmodule Glowworm.Models.Izhikevich.RunnerState do
  @type t :: %__MODULE__{
    event: atom(),
    counter: non_neg_integer(),
  }
  defstruct [:counter, event: nil]
end
