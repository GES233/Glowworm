alias Glowworm.Models.Izhikevich, as: I
alias Glowworm.SomaRunner.RunnerState, as: R

defmodule CurrentInjector do
  @spec do_inject(pid(), number()) :: :ok | {:error, term()}
  def do_inject(_target_soma, _current) do
    # send(_target_soma, _current)

    :ok
  end
end

defmodule Recorder do
  use Agent
  # Record state during agent running.

  def start_link do
    Agent.start_link(fn -> [] end)
  end

  def record(agent, data) do
    Agent.update(agent, fn state -> state ++ [data] end)
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

conf = %{
  model: I,
  param: %I.Param{c: -50.0, d: 2.0},
  send: nil,
  inspect: nil
}

init = %{
  current: %I.InputState{current: 0.0},
  soma: %I.NeuronState{potential: -65.0, recovery: 0.0},
  runner: %R{counter: 0, timestep: 0.01}
}

{:ok, soma_runner} = Glowworm.SomaRunner.start_link(conf, init)

## Do some stuff

:ok = Agent.stop(soma_runner)

## Do other stuff
