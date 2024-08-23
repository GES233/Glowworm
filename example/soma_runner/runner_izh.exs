alias Glowworm.Models.Izhikevich, as: I
alias Glowworm.SomaRunner.RunnerState, as: R

defmodule CurrentInjector do
  @scheduler [
    150,
    165,
    172,
  ]

  def scheduler(), do: @scheduler

  @spec do_inject(pid(), number()) :: :ok | {:error, term()}
  def do_inject(target_soma, current) do
    # current to input.
    state = Agent.get(target_soma, fn {_, _, _, current, _, _} -> current end)

    send(target_soma, %{state | current: current})

    :ok
  end
end

defmodule Recorder do
  use Agent
  # Record state during agent running.

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def record(agent, data) do
    Agent.update(agent, fn state -> [data | state] end)
  end

  def run() do
    # Receive info and add it to state.
    receive do
      # ...
    end

  end

  def show(agent) do
    Agent.get(agent, fn state -> state |> Enum.reverse() end)
  end

end

{:ok, recorder} = Recorder.start_link()

conf = %{
  model: I,
  param: %I.Param{c: -50.0, d: 2.0},
  send: nil,
  inspect: recorder
}

init = %{
  current: %I.InputState{current: 0.0},
  soma: %I.NeuronState{potential: -65.0, recovery: 0.0},
  runner: %R{counter: 0, timestep: 0.01}
}

## Test: single step.
Glowworm.SomaRunner.do_single_step(soma_runner) |> IO.inspect()

## Test: add injector.

## Terminate agent.
:ok = Agent.stop(soma_runner)

## Do other stuff
