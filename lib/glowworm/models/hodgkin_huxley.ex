defmodule Glowworm.Models.HodgkinHuxley do
  use Rustler,
    otp_app: :glowworm,
    crate: :hodgkin_huxley_model

  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
end

defmodule Glowworm.Models.HodgkinHuxley.NeuronState do
  @type t :: %__MODULE__{
          potential: number()
        }
  defstruct [:potential]
end

defmodule Glowworm.Models.HodgkinHuxley.InputState do
  @type t :: %__MODULE__{
          current: number()
        }
  defstruct [:current]
end

defmodule Glowworm.Models.HodgkinHuxley.Param do
  defstruct []
end
