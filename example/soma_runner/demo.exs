defmodule Demo do
  # alias Glowworm.SomaRunner.RunnerState
  alias Glowworm.Models.Izhikevich, as: I

  @timestep 0.01
  @frame_count 512
  @current_map %{
    # Current at frame level.
    p1: {250, 3.0},
    p2: {30, 0.0},
    fin: {256, nil}
  }
  ## Param
  @check_halt true
  @check_pulse true

  def get_timestep(), do: @timestep
  def get_frame() do
    {fin, _} = @current_map.fin

    fin
  end
  def get_total(), do: get_frame() * @frame_count

  def get_current(tick) do
    # TODO:
    # total = @current_map |> get_frame |> sort[-1]
    # rest = @current_map |> get_frame |> sort
    cond do
      tick == 256 * (250+256) ->
        IO.puts("Start inject current at #{get_total() - tick}(#{(get_total() - tick) * @timestep}ms).")

        5.0
        tick > 256 * (200+256) and tick < 256 * (250+256) -> 5.0
      tick == 256 * (200+256) ->
        IO.puts("End inject current at #{get_total() - tick}(#{(get_total() - tick) * @timestep}ms).")

        0.00
      # tick > 256 * 50 and tick <= 256 * 100 -> 3.0
      true -> 0.00
    end
  end

  def calc(s, 0), do: s |> Enum.reverse
  def calc([head | _tail] = s, ct) do
    {neuron, runner} = head
    current = get_current(ct)
    # current = 0.0
    # Used for no change.

    {new_neuron, new_runner} = I.nextstep(
      %I.Param{timestep: @timestep, c: -50.0, d: 2.0}, # chattering
      neuron,
      %I.InputState{current: current},
      runner
    )

    if @check_pulse do
      case new_runner.event do
        :pulse ->
          IO.puts("Pulse at #{get_total() - ct}(#{(get_total() - ct) * @timestep}ms).")
        _ -> nil
      end
    end

    if @check_halt do
      du = new_neuron.recovery - neuron.recovery
      dv = new_neuron.potential - neuron.potential

      case new_runner.counter do
        0 -> cond do
          # In `Glwworm.Neuron`, compare between two frames
          # with counter = 0 and previous step.
          -1.0e-7 <= du and du <= 1.0e-7 and -1.0e-7 <= dv and dv <= 1.0e-7 and current == 0.0 ->
            inspect_halt(du, dv, ct)

            calc([{new_neuron, new_runner} | s], 0)
          true -> calc([{new_neuron, new_runner} | s], ct - 1)
        end
        _ -> calc([{new_neuron, new_runner} | s], ct - 1)
      end
    else
      calc([{new_neuron, new_runner} | s], ct - 1)
    end
  end

  defp inspect_halt(dv, du, ct) do
    IO.puts("δv = #{dv}")
    IO.puts("δu = #{du}")
    IO.puts("Over close threshold since #{get_total() - ct}(#{(get_total() - ct) * @timestep}ms).\nShut down...")
  end
end

cycles = Demo.get_total()
{time, res} = :timer.tc(&Demo.calc/2, [
    [
      {
        %Glowworm.Models.Izhikevich.NeuronState{potential: -65.0, recovery: 0.0},
        %Glowworm.SomaRunner.RunnerState{counter: 0}
      }
    ],
    cycles
])
IO.puts("Total:\n#{res |> length} steps.")
IO.puts("Used #{time}ms for #{Demo.get_timestep() * cycles}ms.\nRatio: #{time / (Demo.get_timestep() * cycles)}.")

split = fn tp ->
  {state, _} = tp

  state
end

line = fn state ->
  "#{Float.to_string(state.potential)},#{Float.to_string(state.recovery)}"
end

raw = Enum.map(res, split)
|> Enum.map(line)
|> Enum.join("\n")

:ok = File.write(
  "example/soma_runner/r_temp.csv",
  "v,u\n" <> raw
)

Mix.Shell.IO.cmd("python example/soma_runner/demo.py --count #{length(res)} --timestep #{Demo.get_timestep()}")
