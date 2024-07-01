defmodule Glowworm.Models.AlphaSynapse do
  @moduledoc """
  `AlphaSynapse` means synapse responce like
  alpha function.
  """
  # Refrences https://www.tusharchauhan.com/writing/models-of-synaptic-conductance-ii/
  use Rustler,
    otp_app: :glowworm,
    crate: :alphasynapse_model

  @behaviour Glowworm.Models

  def nextstep(_param, _state, _input, _runner_state), do: :erlang.nif_error(:nif_not_loaded)

  def to_neuron(_state, _runner_state) do
  end
end

defmodule Glowworm.Models.AlphaSynapse.Param do
  @moduledoc """
  * `tau`
  * `g_amp`  # H_0 also.
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
