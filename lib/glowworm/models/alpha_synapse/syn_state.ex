defmodule Glowworm.Models.AlphaSynapse.SynState do
  @type spike :: :spike
  @type t :: %__MODULE__{
          spike: spike(),
          current: number()
        }
  defstruct [:spike, :current]
end
