defmodule Glowworm.Models.BiExpSynapse do
  @moduledoc """
  `BiExpSynapse` means synapse responce like
  bi-exponential function.
  """
  # Refrences https://www.tusharchauhan.com/writing/models-of-synaptic-conductance-iii/
  use Rustler,
  otp_app: :glowworm,
  crate: :bi_exp_model
  @behaviour Glowworm.Models

  def complete_param(tau_decay, k, _g_amp) do
    _t_peak = (k * tau_decay) / (1 - k) * :math.log(1.0 / k)
  end

  def nextstep(_param, _state, _input, _runner_state), do: :erlang.nif_error(:nif_not_loaded)

  def to_neuron(_state, _runner_state) do
  end
end

defmodule Glowworm.Models.BiExpSynapse.Param do
  @moduledoc """
  * `tau_dacay`
  * `k`
  * `g_amp`  # H_0 also.
  """
  @type t :: %__MODULE__{
    tau_decay: number(),
    k: number(),
    g_amp: number(),
  }
  defstruct [:tau_decay, :k, :g_amp]
end

defmodule Glowworm.Models.BiExpSynapse.SpikeState do
  @moduledoc false
end

defmodule Glowworm.Models.BiExpSynapse.SynapticState do
  @moduledoc """
  ...
  """
  defstruct [:g, :h]
end
