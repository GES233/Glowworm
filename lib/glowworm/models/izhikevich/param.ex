defmodule Glowworm.Models.Izhikevich.Param do
  @moduledoc """
  Parameters used in Izhikevich model.

  ## Parameters

  ### From model

  source:
  [Simple Model of Spiking Neurons](https://www.izhikevich.org/publications/spikes.pdf)

  * `a` - The parameter a describes the time scale of the recovery variable `u`.
  Smaller values result in slower recovery.
  * `b` - The parameter `b` describes the sensitivity of the recovery variable
  `u` to the subthreshold fluctuations of the membrane potential `v`.
  Greater values couple `v` and `u` more strongly resulting in possible
  subthreshold oscillations and low-threshold spiking dynamics.
  * `c` - The parameter `c` describes the after-spike reset value of
  the membrane potential `v` caused by the fast high-threshold K+ conductances.
  * `d` - The parameter `d` describes after-spike reset of the recovery variable
  `u` caused by slow high-threshold Na+ and K+ conductance.

  Except above, has `peak_threshold` field to set the threshold of reset.
  """

  @type t :: %__MODULE__{
          a: number(),
          b: number(),
          c: number(),
          d: number(),
          peak_threshold: number()
        }
  # @enforce_keys [:timestep]
  defstruct a: 0.02, b: 0.2, c: -65.0, d: 8.0, peak_threshold: 30.0
end
