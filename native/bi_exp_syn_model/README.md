# NIF for Elixir.BiExpSynapse

## To build the NIF module:

- Your NIF will now build along with your project.

## To load the NIF:

```elixir
defmodule BiExpSynapse do
  use Rustler, otp_app: :glowworm, crate: "bi_exp_syn_model"

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
end
```

## Examples

[This](https://github.com/rusterlium/NifIo) is a complete example of a NIF written in Rust.
