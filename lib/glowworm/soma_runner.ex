defmodule Glowworm.SomaRunner do
  @moduledoc """
  SomaRunner.

  * Running a frame(256 times)
    - zip the data to neuron.
  * Send event to `Neuron` if `pulse`
  * Adjust timestep
  """
  use Task

  ## Configuration.
  @type conf :: %{
          modules: %{
            param: atom(),
            input: atom(),
            state: atom(),
            runner: atom()
          },
          model: atom(),
          param: map() | struct(),
        }

  @runner_model :soma_runner_model
  @model_params :soma_runner_module_param
  @model_modules [:param, :input, :state, :runner]
  @default_model Glowworm.Models.Izhikevich
  @default_modules %{
    param: Glowworm.Models.Izhikevich.Param,
    input: Glowworm.Models.Izhikevich.InputState,
    state: Glowworm.Models.Izhikevich.NeuronState,
    runner: Glowworm.SomaRunner.RunnerState
  }
  # @steps_number_per_frame 0xff  # Includes 0.

  defp default_module(), do: @default_modules |> Enum.map(fn {k, v} -> {k, v} end)

  defp get_module(_conf_map = %{modules: modules}) , do: modules
  defp get_module(opts) do
    @model_modules
    |> Enum.map(fn field -> {field, Keyword.get(opts ++ default_module(), field)} end)
    |> Map.new()
  end

  defp get_model(_conf_map = %{model: model}) , do: model
  defp get_model(opts), do: Keyword.get(opts, @runner_model, @default_model)

  defp get_param(_conf_map = %{params: params}) , do: params
  defp get_param(opts), do: Keyword.get(opts, @model_params)

  def start_link(args), do: Task.start_link(__MODULE__, :run, args)

  def run({opts}) do
    ## Load runner.
    _runner_module_name = get_module(opts)
    _runner_model = get_model(opts)
    _runner_params = get_param(opts)
  end

  # Simulation.

  # get_current(), do: nil
  # get_neuron_state(), do: nil
  # if has not state(e.g. when initialize) => ...
  # else => when currrent state

  # Wrap `Models.next_step/4`
  def do_single_step() do
    # ...
  end

  # Implemented runner prototype in `Demo`.
  # - continous calculate with recursion
  # - when counter = 0 =>
  #   do_some_stuff(send data to Neuron)
  # - when pulse =>
  #   do_some_stuff(send event to Neuron)
end

defmodule Glowworm.SomaRunner.RunnerState do
  @moduledoc """
  Only used for soma runner.
  """

  # TODO: Add timestep here.
  @type t :: %__MODULE__{
          event: atom(),
          counter: non_neg_integer(),
          timestep: number()
        }
  defstruct [:counter, :timestep, event: nil]
end
