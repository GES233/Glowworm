defmodule Glowworm.Runners.Soma do
  # ...
end

defmodule Glowworm.Runners.Soma.RunnerState do
  @moduledoc """
  Only used for soma runner.
  """

  @type t :: %__MODULE__{
    event: atom(),
    counter: non_neg_integer(),
    timestep: number()
  }
  defstruct [:counter, :timestep, event: nil]
end
