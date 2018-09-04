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

Docs on how to use it with Ecto can be found here [https://hexdocs.pm/ecto_bitfield](https://hexdocs.pm/ecto_bitfield)

## Installation

```elixir
def deps do
  [
    {:ecto_bitfield, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
defmodule User do
  use Ecto.Schema

  import EctoBitfield

  # takes in a list or a keyword list for explicitly setting the mappings
  defbitfield Policies, [:create_user, :update_user, :delete_user]

  schema "users" do
    field :policies, User.Policies
  end
end
```

**Reading**

```elixir
query = from u in User, where: u.policies == ^[:create_user, :update_user]
#> %Ecto.Queryable{...}

user = Repo.one(query)
#> %User{..., policies: [:create_user, :update_user]}
```

**Writing**

```elixir
changeset = Ecto.Changeset.cast(user, %{policies: [:create_user]}, [:policies])
#> %Ecto.Changeset{..., changes: %{policices: 1}}

Repo.update(changeset)
#> {:ok, %User{..., policices: [:create_user]}}
```
