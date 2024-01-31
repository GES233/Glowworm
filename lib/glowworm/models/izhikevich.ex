defmodule Glowworm.Models.Izhikevich do
  use Rustler,
    otp_app: :glowworm,
    crate: :izhikevich_model
  @behaviour Glowworm.Models
  alias Glowworm.Models.Izhikevich, as: M

  @spec nextstep(M.NeuroState, M.Param) :: {M.NeuroState, atom()}
  def nextstep(_state, _param), do: :erlang.nif_error(:nif_not_loaded)
end
