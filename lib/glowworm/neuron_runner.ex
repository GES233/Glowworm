defmodule Glowworn.NeuronRunner do
  @moduledoc """
  NeuronRunner.

  * Running a frame(256 times)
  * Send event to `Neuron` if `pulse`
  """
  use Task
  @default_model Glowworm.Models.Izhikevich

  def start_link(args), do: Task.start_link(__MODULE__, :run, args)

  def run({opts}) do
    _runner_module = Keyword.get(opts, :runner_module, @default_model)
  end

  # defp do_run(), do: nil
  # TODO: Implement runner.
  # - [ ] continous calculate with recursion
  #   - [x] prototype in example
  #   - [ ] here
  # - [ ] when counter = 0 =>
  #   do_some_stuff(send to Neuron)
  # - [ ] when pulse =>
  #   do_some_stuff(send to Neuron)
end
