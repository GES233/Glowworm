defmodule Glowworm.NeuronID do
  @moduledoc false

  @typt t :: %__MODULE__{
    scope: atom(),
    layer: atom() | integer(),
    index: non_neg_integer()
  }
  defstruct [:scope, :layer, :index]

end
