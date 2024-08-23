defmodule Glowworm.SynapseRunner do
  # alias :gen_statem, as: GenStateM

  # @behaviour GenStateM
end

defmodule Glowworm.SynapseRunner.RunnerState do
  @type t :: %__MODULE__{
          current: number(),
          counter: non_neg_integer(),
          timestep: number()
        }
  defstruct [:current, :counter, :timestep]
end
