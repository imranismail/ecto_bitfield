# EctoBitfield

Provides functionality similar to [Ruby's bitfields](https://github.com/grosser/bitfields/)

## Motivation

Say you have a user schema that can have one or more of the following service policy [:create_user, :update_user, :delete_user]

To pack that information into a bit we'd do something like this

policies = [create_user: 2^0, update_user: 2^1, delete_user: 2^2]

| create_user    | update_user    | delete_user    | BIT |
|----------------|----------------|----------------|-----|
| F              | F              | F              | 0   |
| T              | F              | F              | 1   |
| F              | T              | F              | 2   |
| T              | T              | F              | 3   |
| F              | F              | T              | 4   |
| T              | F              | T              | 5   |
| F              | T              | T              | 6   |
| T              | T              | T              | 7   |

This saves you a couple of migrations and headache and is also is memory efficient.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_bitfield` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_bitfield, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ecto_bitfield](https://hexdocs.pm/ecto_bitfield).

