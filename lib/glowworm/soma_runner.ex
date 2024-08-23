defmodule Glowworm.SomaRunner do
  @moduledoc """
  SomaRunner.

  * Running a frame(256 times)
    - zip the data to neuron.
  * Send event to `Neuron` if `pulse`
  * Adjust timestep
  """
  # alias Glowworm.SomaRunner.RunnerState, as: R
  alias :gen_statem, as: GenStateM

  @behaviour GenStateM

  @impl GenStateM
  def callback_mode, do: :state_functions

  @impl GenStateM
  def init(_args) do
    {:ok, :init, nil}
  end

end

defmodule Glowworm.SomaRunner.RunnerState do
  @moduledoc """
  Only used for soma runner.
  """

  # TODO: Add timestep here.
  @type t :: %__MODULE__{
          event: atom(),
          counter: non_neg_integer(),
          timestep: number()
        }
  defstruct [:counter, :timestep, event: nil]
end
