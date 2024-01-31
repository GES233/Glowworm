defmodule Glowworm.NetConfig do
  defstruct [
    runner_model: Glowworn.Models.Izhikecivh,
    num_neurons: 64
  ]

  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  end
end
