defmodule Glowworm.Models.Izhikevich.NeuronState do
  @type t :: %__MODULE__{
          potential: number(),
          recovery: number()
        }
  defstruct [:potential, :recovery]
end

defmodule Glowworm.Models.Izhikevich.InputState do
  @type t :: %__MODULE__{
          current: number()
        }
  defstruct [:current]
end
