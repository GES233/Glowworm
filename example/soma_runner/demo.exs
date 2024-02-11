defmodule Demo do
  alias Glowworm.SomaRunner.RunnerState
  alias Glowworm.Models.Izhikevich, as: I

  @timestep 0.01
  @frame_count 256
  @current_map %{
    # Current at frame level.
    p1: {250, 3.0},
    p2: {30, 0.0},
    fin: {256, nil}
  }

  def get_timestep(), do: @timestep
  def get_frame() do
    {fin, _} = @current_map.fin

    fin
  end
  def get_total(), do: get_frame() * @frame_count

  def get_current(_tick) do
    # total = @current_map |> get_frame |> sort[-1]
    # rest = @current_map |> get_frame |> sort
  end

  def calc(s, 0), do: s |> Enum.reverse
  def calc([head | _tail] = s, ct) do
    {neuron, runner} = head
    current = cond do
      ct == 256 * 250 ->
        IO.puts("Start inject current at #{(get_total()-ct) * @timestep}ms.")

        5.0
      ct > 256 * 30 and ct < 256 * 250 -> 5.0
      ct == 256 * 30 ->
        IO.puts("End inject current at #{(get_total()-ct) * @timestep}ms.")

        0.05
      # ct > 256 * 50 and ct <= 256 * 100 -> 3.0
      true -> 0.05
    end

    {new_neuron, new_runner} = I.nextstep(
      %I.Param{timestep: @timestep, c: -50.0, d: 2.0}, # chattering
      neuron,
      %I.InputState{current: current},
      runner
    )

    case new_runner.event do
      :pulse ->
        IO.puts("Pulse at #{(get_total()-ct) * @timestep}ms.")
      _ -> nil
    end

    calc([{new_neuron, new_runner} | s], ct - 1)
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
IO.puts("====\nUsed #{time}ms for #{Demo.get_timestep() * cycles}ms.\nRatio: #{time / (Demo.get_timestep() * cycles)}.")

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

Mix.Shell.IO.cmd("python example/soma_runner/demo.py")
# TODO: Send args with `cycles`.
