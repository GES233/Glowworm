
defmodule Glowworm.Models.AlphaSynapse.Param do
  @moduledoc """
  * `tau`
  * `g_amp`  *also is* `H_0`
  """

  # It's may not stable when tring to
  # implement neural plasticity.

  @type t :: %__MODULE__{
          tau: number(),
          g_amp: number()
        }
  defstruct [:tau, :g_amp]
end

defmodule Glowworm.Models.AlphaSynapse.SynapticState do
  @moduledoc """
  ...
  """
  defstruct [:g, :h]
end


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

  @type input_state :: {
    any(),    # pulse
    number()  # Potential
  }

  def nextstep(_param, _state, _input, _runner_state), do: :erlang.nif_error(:nif_not_loaded)

  # TODO: implement it after finish SynapseRunner
  def check_stable(_state1 = %S.SynapticState{}, _state2 = %S.SynapticState{}, _input), do: false
end
