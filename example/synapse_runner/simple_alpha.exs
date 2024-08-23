defmodule SimpleSynapse do
  # alias Glowworm.SynapseRunner.RunnerState, as: Runner
  alias Glowworm.Models.AlphaSynapse, as: S

  @timestep 0.01
  @frame_count 512
  @total_frame 20
  @g_amp 5.0
  @spike_map [0, 5000, 5200, 5350]

  def get_timestep(), do: @timestep
  def get_total(), do: @total_frame * @frame_count

  def get_pulse(ct) do
    if (get_total() - ct) in @spike_map do
      IO.puts(ct)

      :pulse
    else
      nil
    end
  end

  def calc(s, 0),
    do:
      s
      |> Enum.map(&pulse_opt/1)
      |> Enum.reverse()

  def calc([head | _] = s, ct) do
    # Make graphing easier.
    {syn, runner, _} = head
    pulse = get_pulse(ct)

    {next_syn, next_runner} =
      S.nextstep(
        %S.Param{tau: 10.0, g_amp: @g_amp},
        syn,
        pulse,
        runner
      )

    calc([{next_syn, next_runner, pulse} | s], ct - 1)
  end

  defp pulse_opt(item) do
    {syn, runner, pulse} = item

    state =
      case pulse do
        nil -> false
        _ -> true
      end

    {syn, runner, state}
  end
end

{time, res} =
  :timer.tc(&SimpleSynapse.calc/2, [
    [
      {
        %Glowworm.Models.AlphaSynapse.SynapticState{g: 0.0, h: 0.0},
        %Glowworm.SynapseRunner.RunnerState{current: 0.0, counter: 0, timestep: 0.01},
        nil
      }
    ],
    SimpleSynapse.get_total()
  ])

IO.puts("Running #{length(res)} steps for #{time} ms.")

split = fn item ->
  {syn, _, pulse} = item

  {syn, pulse}
end

line = fn {state, pulse} ->
  "#{Float.to_string(state.g)},#{Float.to_string(state.h)},#{Atom.to_string(pulse)}"
end

raw =
  Enum.map(res, split)
  |> Enum.map(line)
  |> Enum.join("\n")

type = "alpha_g"

:ok =
  File.write(
    "example/synapse_runner/#{type}_temp.csv",
    "g,h,spike\n" <> raw
  )

Mix.Shell.IO.cmd(
  "python example/synapse_runner/show.py --type #{type} --count #{length(res)} --timestep #{SimpleSynapse.get_timestep()}"
)
