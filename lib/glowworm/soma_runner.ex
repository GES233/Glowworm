defmodule Glowworm.SomaRunner do
  @moduledoc """
  SomaRunner.

  There're three states:
  * `:idle` --> do nothing until has simulus.
  * `:with_current` --> update I --> update S, R
  * `:without_current` --> update S, R

  where `I` means input current, `S` means soma's
  state, and `R` means runner state.

  when in activation(not in `:idle`), the runner has
  periodic event during counter of runner state is zero.
  Usually adjust timestep or do anything else.
  """

  alias Glowworm.Models, as: M
  alias Glowworm.SomaRunner, as: R
  alias :gen_statem, as: GenStateM
  # About gen_statem, see:
  # https://meraj-gearhead.ca/state-machine-in-elixir-using-erlangs-genstatem-behaviour

  @behaviour GenStateM

  @type state :: :idle | :with_current | :without_current
  @type container :: {M.param(), M.state(), M.input(), R.RunnerState.t()}
  @type machine_state :: %{
    state: state(),
    container: container(),
    # model name(atom).
    # send and inspect related.
  }

  @impl GenStateM
  def callback_mode, do:
    :handle_event_function

  @impl GenStateM
  def start_link(neuron_id, args) do
    GenStateM.start_link(__MODULE__, args, name: neuron_id)
  end

  @impl GenStateM
  def init(_args) do
    {:ok, :init, nil}
  end

  def child_spec(opts) do
    {neuron_id, args} = opts

    %{
      id: neuron_id,
      start: {__MODULE__, :start_link, [args]},
    }
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
