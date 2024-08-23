defmodule Glowworm do
  @moduledoc """
  Documentation for `Glowworm`.
  """

  ## Message spec

  # It can be used in anywhere, include in
  # runners and neurons, so put it in here.

  @type msg_payload() :: any()

  @typedoc """
  `event` is the message between neuron and runners.
  """
  @type event :: {:event, msg_payload()}

  @typedoc """
  `state` sharing state in runner to other place.
  """
  @type state :: {:state, msg_payload()}

  @typedoc """
  `pulse` sended between neurons.
  """
  @type pulse :: {:pulse, msg_payload()}
end
