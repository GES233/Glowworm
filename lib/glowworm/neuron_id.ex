defmodule Glowworm.NeuronID do
  @moduledoc false

  @type t :: %__MODULE__{
          scope: atom(),
          layer: atom() | integer(),
          index: non_neg_integer()
        }
  @type sqeezed :: atom()
  defstruct [:scope, :layer, :index]

  def new(scope, layer, index) do
    %__MODULE__{scope: scope, layer: layer, index: index}
  end

  def sqeeze(%__MODULE__{} = neuron_id),
    do: :"#{neuron_id.scope}_#{neuron_id.layer}_#{neuron_id.index}"

  def sqeeze(_), do: nil

  def unsqueeze(id) when is_atom(id) do
    unsqueeze(Atom.to_string(id))
  end

  def unsqueeze(id) do
    [scope, layer, index] = String.split(id, "_")

    unsqueeze(scope, layer, index)
  end

  def unsqueeze(scope, layer, index) do
    cond do
      layer =~ ~r/\d+/ ->
        %__MODULE__{
          scope: scope,
          layer: String.to_integer(layer),
          index: String.to_integer(index)
        }

      true ->
        %__MODULE__{
          scope: scope,
          layer: String.to_atom(layer),
          index: String.to_integer(index)
        }
    end
  end
end
