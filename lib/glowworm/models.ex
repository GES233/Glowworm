defmodule Glowworm.Models do
  @type status :: map() | struct()
  @type param :: map() | struct()
  @type input :: map() | struct()
  @callback nextstep(param, status, input) :: {status, atom() | nil}
end
