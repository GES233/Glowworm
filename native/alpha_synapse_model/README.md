# NIF for Elixir.Glowworm.Models.AlphaSynapse

## To build the NIF module:

- Your NIF will now build along with your project.

## To load the NIF:

```elixir
defmodule Glowworm.Models.AlphaSynapse do
  use Rustler, otp_app: :glowworm, crate: "alpha_synapse_model"

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
end
```

## Examples

[This](https://github.com/rusterlium/NifIo) is a complete example of a NIF written in Rust.
