defmodule Demo do
  alias Glowworm.Models.Izhikevich, as: I

  @timestep 0.01

  def get_timestep(), do: @timestep

  def calc(s, 0), do: s |> Enum.reverse
  def calc([head | _tail] = s, ct) do
    current = cond do
      ct > 256 * 30 and ct < 256 * 200 -> 5.0
      # ct > 256 * 50 and ct <= 256 * 100 -> 3.0
      true -> 0.05
    end

    {new, status} = I.nextstep(
      %I.Param{timestep: @timestep, c: -50.0, d: 2.0}, # chattering
      head,
      %I.InputState{current: current, counter: 0}
    )

    case status do
      :pulse -> IO.puts("Pulse!")
      _ -> nil
    end

    calc([new | s], ct - 1)
  end
end

cycles = 256 * 256  # 256 frames
{time, res} = :timer.tc(&Demo.calc/2, [
    [%Glowworm.Models.Izhikevich.NeuronState{potential: -65.0, recovery: 0.0}],
    cycles
])
IO.puts("Used #{time}ms for #{Demo.get_timestep() * cycles}ms.\nRatio: #{time / (Demo.get_timestep() * cycles)}.")

line = fn state -> "#{(state.potential) |> Float.to_string()},#{(state.recovery) |> Float.to_string()}" end
raw_data = Enum.map(res, line)
  |> Enum.join("\n")

:ok = File.write("example/r_temp.csv", "v,u\n" <> raw_data)

Mix.Shell.IO.cmd("python example/neuron_runner/demo.py")
