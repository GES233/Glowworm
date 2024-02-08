defmodule Glowworm.Models do
  @type status :: map() | struct()
  @type param :: map() | struct()
  @type input :: map() | struct()
  @type extra_status :: Glowworm.Models.RunnerState.t() | any()
  @callback nextstep(param, status, input, extra_status) :: {status, extra_status}
end

defmodule Glowworm.Models.RunnerState do
  @type t :: %__MODULE__{
    event: atom(),
    counter: non_neg_integer(),
  }
  defstruct [:counter, event: nil]
end
