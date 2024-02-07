defmodule Glowworm.Models do
  @type status :: map() | struct()
  @type param :: map() | struct()
  @type input :: map() | struct()
  @type extra_status :: map() | struct() | any()
  @callback nextstep(param, status, input, extra_status) :: {status, extra_status}
end
