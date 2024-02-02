defmodule Demo do
  alias Glowworm.Models.Izhikevich, as: I

  @timestep 0.01

  def get_timestep(), do: @timestep

  def calc(s, 0), do: s |> Enum.reverse
  def calc([head | _tail] = s, ct) do
    {new, _status} = I.nextstep(
      %I.Param{timestep: @timestep},
      head,
      %I.InputState{current: 0.1, counter: 0}
    )
    calc([new | s], ct - 1)
  end
end

cycles = 100
{time, _res} = :timer.tc(&Demo.calc/2, [
    [%Glowworm.Models.Izhikevich.NeuronState{potential: -65.0, recovery: -13.0}],
    cycles
])
IO.puts("Used #{time}ms for #{Demo.get_timestep() * cycles}ms.\nRatio: #{time / (Demo.get_timestep() * cycles)}.")
