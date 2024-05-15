defmodule Glowworm.Models.AlphaSynapse.SynState do
  @type t :: %__MODULE__{
          conductance: number(),
          current: number(),
          # Implement shor-term plasticity.
          # ref: https://www.youtube.com/watch?v=AiExcSomrvc&t=432s
          x: number(),  # fraction available
          u: number(),  # probability_of_release
        }
  defstruct [:conductance, :current, :x, :u]
end

defmodule Glowworm.Models.AlphaSynapse.Input do
  @typedoc """
  Spike from presynaptic neuron.
  """
  @type spike :: Glowworm.Neuron.State.output_spike()

  @typedoc """
  Potential from membrane.
  """
  @type potentail :: number()

  @type t :: %__MODULE__{
          spike: spike(),
          potential: potentail()
        }
  defstruct [:spike, :potential]
end
