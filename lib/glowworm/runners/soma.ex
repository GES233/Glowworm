defmodule Glowworm.Runners.Soma do
  # ...
  alias Glowworm.Runners, as: Runner
  alias Glowworm.Models, as: M
  use Runner, :runner

  @type t :: %__MODULE__{
    model: atom(),
    neuron_id: atom(),
    agents: %{
      input_storage: pid(),
      runner_loop_agent: pid(),
      # State and VParam.
      runner_state_storage: pid()
      # RunnerState.
    } | nil,
    conn: %{} | nil,
    prev_res_frame_0: M.nextstep_output()
  }
  defstruct [
    # Stable during running.
    :model, :neuron_id, :agents,
    # Maybe changing
    :conn, :prev_res_frame_0,
  ]

  @type state :: {atom(), atom(), t()}

  ## Options

  @impl true
  def callback_mode(), do: :state_functions

  ## API

  # start/1
  # start_link/1
  # stop/1

  ## Internal functions

  def get_neuron_id_from_args(args) do
    Keyword.get(args, :neuron_id)
    |> case do
      nil -> :"neuron_#{for _ <- 1..6, into: "", do: <<Enum.random('0123456789abcdef')>>}"
      res = _ -> ID.sqeeze(res)
    end
  end

  @spec build_init_state(keyword()) :: t()
  def build_init_state(args) do
    model = Keyword.get(args, :model, Glowworm.Models.Izhikevich)
    neuron_id = get_neuron_id_from_args(args)
    # [TODO) Spawn link between current process and agents.
    %__MODULE__{model: model, neuron_id: neuron_id}
  end

  ## Mandatory callbacks

  @impl true
  def init(args) do
    # https://andrealeopardi.com/posts/connection-managers-with-gen-statem/
    actions = [{:next_event, :internal, :connect}]
    {:ok, :idle, build_init_state(args), actions}
  end

  @impl true
  def terminate(_reason, _current_state, _data) do
    IO.puts("Soma Runner Terminated.")
  end

  ## State callbacks

  # idle
  def idle(:internal, :connect, _data) do
    # ...
  end
end

defmodule Glowworm.Runners.Soma.RunnerState do
  @moduledoc """
  Only used for soma runner.
  """

  @type t :: %__MODULE__{
    event: atom(),
    counter: non_neg_integer(),
    timestep: number()
  }
  defstruct [:counter, :timestep, event: nil]
end

defmodule Glowworm.Runners.Soma.Input do
  @moduledoc """
  Agent container to store input.
  """
  alias Glowworm.Runners, as: Runner
  use Runner, :agent
end

defmodule Glowworm.Runners.Soma.RunnerLoop do
  @moduledoc """
  Agent container to store state and execute loop.

  Spawned when Soma Runner initialized.
  """
  # alias Glowworm.Runners, as: Runner
  # use Runner, :loop
end

defmodule Glowworm.Runners.Soma.P do
  @moduledoc """
  Agent container to store variable param.
  """
  alias Glowworm.Runners, as: Runner
  use Runner, :agent
end
