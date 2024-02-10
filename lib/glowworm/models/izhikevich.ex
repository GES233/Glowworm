defmodule Glowworm.Models.Izhikevich do
  use Rustler,
    otp_app: :glowworm,
    crate: :izhikevich_model

  @behaviour Glowworm.Models
  alias Glowworm.NeuronRunner.RunnerState
  alias Glowworm.Models.Izhikevich, as: M

  @spec nextstep(M.Param, M.NeuronState, M.InputState, RunnerState) ::
          {M.NeuronState, RunnerState}
  def nextstep(_param, _state, _input, _runner), do: :erlang.nif_error(:nif_not_loaded)

  def generic(status) do
    %{v: status.potential}
  end
end
