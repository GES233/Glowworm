defmodule Glowworm.Runners.Sync do
  @moduledoc """
  Intergrate all runners and running it
  in a synchrone method.
  """
  use Agent

  # alias Glowworm.Runners.Soma.RunnerState, as: SomaState
  # alias Glowworm.Runners.Synapse.RunnerState, as: SynState

  def start_link(neuron_id, args) do
    Agent.start_link(__MODULE__, :run, [args], name: neuron_id)
  end

  def child_spec(arg) do
    {neuron_id, other} = arg

    %{
      id: neuron_id,
      start: {__MODULE__, :start_link, [neuron_id, other]},
      type: :worker
    }
  end

  defp get_soma(), do: nil
  defp get_syns(), do: nil

  defp prelude() do
    _soma = get_soma()
    _syns = get_syns()

    %{}
  end

  def execute_chunk() do
    # ...

    _ = prelude()
  end
end

defmodule Glowworm.Neuron.SyncRunner.Conf do
  # Value container while running.
end
