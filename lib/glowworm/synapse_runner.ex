defmodule Glowworm.SynapseRunner do
  use Agent

  def start_link(args), do: Agent.start_link(__MODULE__, :run, args)

  def run({opts}) do
    _runner_module = Keyword.get(opts, :runner_module)
  end
end

defmodule Glowworm.SynapseRunner.RunnerState do
  @type t :: %__MODULE__{
          current: number(),
          counter: non_neg_integer(),
          timestep: number()
        }
  defstruct [:current, :counter, :timestep]
end
