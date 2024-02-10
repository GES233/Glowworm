defmodule Glowworm.Models.LIF do
  use Rustler,
    otp_app: :glowworm,
    crate: :lif_model

  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)

  @behaviour Glowworm.Models
  alias Glowworm.NeuronRunner.RunnerState
  alias Glowworm.Models.LIF, as: M

  @spec nextstep(M.Param, M.NeuronState, M.InputState, RunnerState) ::
          {M.NeuronState, RunnerState}
  def nextstep(_param, _state, _input, _runner), do: :erlang.nif_error(:nif_not_loaded)

  def generic(status) do
    %{v: status.potential}
  end
end
