defmodule Glowworm.SomaRunner do
  @moduledoc """
  SomaRunner.

  * Running a frame(256 times)
    - zip the data to neuron.
  * Send event to `Neuron` if `pulse`
  * Adjust timestep
  """
  use Task
  @default_model Glowworm.Models.Izhikevich
  # TODO: fetch module from config.

  defp get_module(opts), do: Keyword.get(opts, :runner_module, @default_model)

  def start_link(args), do: Task.start_link(__MODULE__, :run, args)

  def run({opts}) do
    _runner_module = get_module(opts)
  end

  # @frame_count 0xff
  # defp do_run(), do: nil
  # TODO: Implement runner.
  # - [ ] continous calculate with recursion
  #   - [x] prototype in example
  #   - [ ] here
  # - [ ] when counter = 0 =>
  #   do_some_stuff(send data to Neuron)
  # - [ ] when pulse =>
  #   do_some_stuff(send event to Neuron)
end

defmodule Glowworm.SomaRunner.RunnerState do
  @moduledoc """
  Only used for soma runner.
  """
  @type t :: %__MODULE__{
          event: atom(),
          counter: non_neg_integer()
        }
  defstruct [:counter, event: nil]
end
