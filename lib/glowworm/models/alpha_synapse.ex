defmodule Glowworm.Models.AlphaSynapse do
  @moduledoc """
  `AlphaSynapse` means synapse responce like
  alpha function.
  """
  # Refrences https://www.tusharchauhan.com/writing/models-of-synaptic-conductance-ii/
  use Rustler,
    otp_app: :glowworm,
    crate: :alphasynapse_model

  alias Glowworm.Models.AlphaSynapse, as: S
  @behaviour Glowworm.Models

  def nextstep(_param, _state, _input, _runner_state), do: :erlang.nif_error(:nif_not_loaded)

  # TODO: impliment it after finish SynapseRunner
  def check_stable(%S.SynapticState{}, %S.SynapticState{}, _input), do: false
end

defmodule Glowworm.Models.AlphaSynapse.Param do
  @moduledoc """
  * `tau`
  * `g_amp`  *also is* `H_0`
  """
  @type t :: %__MODULE__{
          tau: number(),
          g_amp: number()
        }
  defstruct [:tau, :g_amp]
end

defmodule Glowworm.Models.AlphaSynapse.SpikeState do
  @moduledoc false
  # Reserved.
end

defmodule Glowworm.Models.AlphaSynapse.SynapticState do
  @moduledoc """
  ...
  """
  defstruct [:g, :h]
end
