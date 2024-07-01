defmodule SimpleSynapse do
  alias Glowworm.SynapseRunner.RunnerState, as: Runner
  alias Glowworm.Models.AlphaSynapse, as: S

  @timestep 0.01
  @frame_count 512
  @g_amp 5.0
  @spike_map []

  def get_pulse(_ct), do: nil

  def clac(s, 0), do: s |> Enum.reverse()
  def clac([head | _] = s, ct) do
    {syn, runner} = head
    pulse = get_pulse(ct)

    {next_syn, next_runner} = S.nextstep(
      %S.Param{tau: 10.0, g_amp: @g_amp},
      syn,
      pulse,
      runner
    )

    clac([{next_syn, next_runner} | s], ct - 1)
  end
end

# 2 rows of graph
# -- spike
# -- conductance
# -- current
