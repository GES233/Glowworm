defmodule Glowworm.SynapseRunner do
  use Task
  # Task, or Agent?

  def start_link(args), do: Task.start_link(__MODULE__, :run, args)

  def run({opts}) do
    _runner_module = Keyword.get(opts, :runner_module)
  end
end

defmodule Glowworm.SynapseRunner.RunnerState do
  @type t :: %__MODULE__{
          current: number(),
          counter: non_neg_integer(),
          extra: list(number()) | nil,
          # `extra` used to storage,
          # because of its properties.
        }
  defstruct [:current, :counter, extra: nil]
end
