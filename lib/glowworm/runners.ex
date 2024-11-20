defmodule Glowworm.Runners do
  @moduledoc """
  TODO: Present some content about runner.
  """

  # As data container.
  def agent do
    quote do
      import Glowworm.Runners, except: [runner: 0, loop: 0]

      use Agent

      # @callback name(neuron_id :: any()) :: atom()
    end
  end

  def loop do
    quote do
      import Glowworm.Runners, except: [runner: 0, agent: 0]

      use GenServer
    end
  end

  def runner do
    quote do
      # Glowworm.Runners.agent/0 only used when as Agent.
      import Glowworm.Runners, except: [agent: 0, loop: 0]

      alias Glowworm.NeuronID, as: ID
      alias :gen_statem, as: GenStateM
      @behaviour GenStateM
    end
  end

  defmacro __using__(func) when is_atom(func) do
    apply(__MODULE__, func, [])
  end
end
