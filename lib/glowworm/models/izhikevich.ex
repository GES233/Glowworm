defmodule Glowworm.Models.Izhikevich do
  use Rustler,
    otp_app: :glowworm,
    crate: :izhikevich_model
  @behaviour Glowworm.Models
  alias Glowworm.Models.Izhikevich, as: M

  @spec nextstep(M.Param, M.NeuronState, M.InputState) :: {M.NeuronState, atom()}
  def nextstep(_param, _state, _input), do: :erlang.nif_error(:nif_not_loaded)
end
