defmodule Glowworm.Models.LIF.Param do
  @type t :: %__MODULE__{
          r: number(),
          c: number(),
          tau: number(),
          peak_threshold: number(),
          # Its name is peak because of its complex reset strategy
          reset_value: number(),
          reset_strategy: :dec | :reset | :ignore
        }
  defstruct [:r, :c, :tau, :peak_threshold, :reset_value, reset_strategy: :dec]
end

defmodule Glowworm.Models.LIF.Param.InvalidReset do
  # TODO
  defexception [:message]
end
