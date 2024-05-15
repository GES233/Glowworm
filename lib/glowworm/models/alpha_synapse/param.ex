defmodule Glowworm.Models.AlphaSynapse.Param do
  @type t :: %__MODULE__{
    tau: number(),
    timestep: number()
  }
  defstruct [:tau, :timestep]
end
