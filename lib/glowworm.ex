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

  @typedoc """
  `chunk` like a straming message, ONLY used for SynapseRunner -> SomaRunner.
  """
  @type chunk :: {:chuck, msg_payload()}

  @type update :: {:update, msg_payload()}

  # activate and freeze
  @type activation :: {:activate, msg_payload()} | {:freeze, msg_payload()} | {:halt, msg_payload()}

  @type msg() :: event() | state() | pulse() | chunk() | update() | activation()
end

# Need protocals?
