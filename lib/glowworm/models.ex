defmodule Glowworm.Models do
  @type status :: map() | struct()
  @type param :: map() | struct()
  @callback nextstep(status, param) :: status
end
