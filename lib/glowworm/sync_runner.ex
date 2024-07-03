defmodule Glowworm.Neuron.SyncRunner do
  @moduledoc """
  Intergrate all runners and running it
  in a synchrone method.
  """
  use Task

  #alias Glowworm.SomaRunner.RunnerState, as: SomaState
  #alias Glowworm.SynapseRunner.RunnerState, as: SynState

  def start_link(args) do
    Task.start_link(__MODULE__, :run, [args])
  end

  defp get_soma(), do: nil
  defp get_syns(), do: nil

  defp prelude() do
    _soma = get_soma()
    _syns = get_syns()

    %{}
  end

  def execute_frame() do
    # ...

    _ = prelude()
  end
end

defmodule Glowworm.Neuron.SyncRunner.Conf do
  # Value container while running.
end
