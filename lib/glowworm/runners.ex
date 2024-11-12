defmodule Glowworm.Runners do
  @moduledoc """
  TODO: Present some content about runner.
  """

  # As data container.
  def agent do
    quote do
      use Agent
    end
  end

  def runner do
    quote do
      alias :gen_statem, as: GenStateM

      # ...
    end
  end

  defmacro __using__(func) when is_atom(func) do
    apply(__MODULE__, func, [])
  end
end
