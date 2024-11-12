defmodule Glowworm.Runners.Synapse do
  # ...
end

defmodule Glowworm.Runners.Synapse.RunnerState do
  @type t :: %__MODULE__{
    current: number(),
    counter: non_neg_integer(),
    timestep: number()
  }
  defstruct [:current, :counter, :timestep]
end
