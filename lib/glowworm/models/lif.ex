defmodule Glowworm.Models.LIF do
  use Rustler,
    otp_app: :glowworm,
    crate: :lif_model

  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
end
