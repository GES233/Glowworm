alias Glowworm, as: G
alias Glowworm.SomaRunner, as: SR
alias :gen_statem, as: GenStateM

## TODO: implement current injector
# it's a simple injector that will be used to inject the current value
# into the soma runner via send message to the soma runner process
# the injector will be started as a child of the soma runner process
defmodule CurrentInjector do
  use Agent

  # pulse -> several current sequence
  # ms
  @injector_timestep 10
  @timestep 0.05
  @next_pulse [1500, 3200, 5540]

  @type state() :: %{soma_runner: pid(), current: number(), next_pulse: [number()]}

  def start_link(soma_runner) do
    Agent.start_link(fn -> init(soma_runner) end, name: __MODULE__)
  end

  def init(soma) do
    %{soma_runner: soma, current: 0.0, next_pulse: @next_pulse}
  end

  def run(pid) do
    state = Agent.get(pid, & &1)

    send(state.soma_runner, {:inject_current, state.current})

    Agent.update(pid, fn state ->
      %{
        state
        | current: run_single_step(state.current),
          next_pulse:
            state.next_pulse
            |> Enum.map(&(&1 - @injector_timestep))
            |> Enum.reject(&(&1 <= 0))
      }
    end)

    :timer.sleep(@injector_timestep)

    case Agent.get(pid, & &1.next_pulse) do
      [] -> Agent.stop(pid)
      _ -> run(pid)
    end
  end

  def run_single_step(+0.0), do: +5.0
  def run_single_step(prev_current), do: prev_current - prev_current * @timestep
end

# test
defmodule FakeReceiver do
  def loop() do
    receive do
      {:inject_current, value} -> IO.puts("current: #{value}")
    end

    loop()
  end
end

# test_pid = spawn(FakeReceiver, :loop, [])
# {:ok, injector} = CurrentInjector.start_link(test_pid)
# CurrentInjector.run(injector)

## TODO: implement pulse receiver

## TODO: implement inspector

{:ok, soma_runner} = SR.start_link()
# {:ok, injector} = CurrentInjector.start_link(soma_runner)

## Fin.
GenStateM.stop(soma_runner)

## Process result.
#  ...
