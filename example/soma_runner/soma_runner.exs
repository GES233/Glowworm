# alias Glowworm, as: G
alias Glowworm.SomaRunner, as: SR
# alias :gen_statem, as: GenStateM

defmodule CurrentInjector do
  use Agent

  # pulse -> several current sequence
  # ms
  @injector_timestep 10
  @timestep 0.05
  @next_pulse [150, 210, 290, 554] |> Enum.map(&(&1 * @injector_timestep))
  @halt_tick 1000 * @injector_timestep

  @type state() :: %{soma_runner: pid(), current: number(), next_pulse: [number()]}

  def start_link(soma_runner) do
    Agent.start_link(fn -> init(soma_runner) end, name: __MODULE__)
  end

  def init(soma) do
    %{soma_runner: soma, current: 0.0, next_pulse: @next_pulse, halt_tick: @halt_tick}
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
            |> Enum.map(&(&1 - @injector_timestep)),
          halt_tick: state.halt_tick - @injector_timestep
      }
    end)

    :timer.sleep(@injector_timestep)

    case Agent.get(pid, & &1.next_pulse) do
      [next_pulse | _] ->
        cond do
          next_pulse <= 0 ->
            Agent.update(pid, fn state ->
              %{
                state
                | current: run_single_step(0.0),
                  next_pulse: state.next_pulse |> Enum.reject(&(&1 <= 0))
              }
            end)

          true ->
            nil
        end

      [] ->
        nil
    end

    case Agent.get(pid, & &1.halt_tick) do
      0 ->
        IO.puts("Halted!")

        Agent.stop(pid)

      _ ->
        run(pid)
    end
  end

  def run_single_step(+0.0), do: +5.0
  def run_single_step(prev_current), do: prev_current - prev_current * @timestep
end

defmodule PulseReceiver do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{pulses: [], current_frame: 0} end, name: __MODULE__)
  end

  def run() do
    ht =
      receive do
        # pulse
        {:pulse, runner_state} ->
          runner_state
          |> parse_pulse()
          |> do_update_pulse()

          false

        # update frame
        :update ->
          do_update_frame()

          false

        # halt
        :halt ->
          true

        _ ->
          true
      end

    case ht do
      true -> show_pulses()
      _ -> run()
    end
  end

  # from Inspector
  def do_update_frame(),
    do:
      Agent.update(__MODULE__, fn state -> %{state | current_frame: state.current_frame + 1} end)

  # from SomaRunner
  def parse_pulse(runner_state), do: runner_state.counter

  def do_update_pulse(current_counter) do
    Agent.update(__MODULE__, fn state ->
      %{state | pulses: [state.current_frame * 256 + current_counter | state.pulses]}
    end)
  end

  def show_pulses() do
    Agent.get(__MODULE__, Enum.reverse(& &1.pulses))
  end
end

## TODO: implement inspector
defmodule Inspector do
  use Agent

  @type frame_idx :: pos_integer()
  @type state() :: %{
          # Send message when received :pulse from soma runner.
          pulse: pid(),
          container: %{frame_idx() => [{SR.container(), SR.RunnerState.t()}]}
        }

  def start_link(pulse_agent) do
    Agent.start_link(fn -> %{pulse: pulse_agent, container: %{0 => []}} end, name: __MODULE__)
  end
end

# Prelude.
# {:ok, pulse_receiver} = PulseReceiver.start_link()
# {:ok, inspector} = Inspector.start_link(pulse_receiver)
# {:ok, soma_runner} = SR.start_link(...)
# {:ok, injector} = CurrentInjector.start_link(soma_runner)

# Begin simulation.
# ...

## Fin.
# GenStateM.stop(soma_runner)
# Send {:halt, nil} to PulseReceiver

## Process and show result.
#  ...
