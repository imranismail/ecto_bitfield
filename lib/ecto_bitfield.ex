defmodule EctoBitfield do
  @moduledoc """
  Provides macro to support Bitfield datatype with Ecto

      defmodule User do
        use Ecto.Schema

        import EctoBitfield

        # takes in a list or a keyword list for explicitly setting the mappings
        defbitfield Policies, [:create_user, :update_user, :delete_user]

        schema "users" do
          field :policies, User.Policies
        end
      end

  Reading:

      query = from u in User, where: u.policies == ^[:create_user, :update_user]
      #> %Ecto.Queryable{...}

      user = Repo.one(query)
      #> %User{..., policies: [:create_user, :update_user]}

  Writing:

      changeset = Ecto.Changeset.cast(user, %{policies: [:create_user]}, [:policies])
      #> %Ecto.Changeset{..., changes: %{policices: 1}}

      Repo.update(changeset)
      #> {:ok, %User{..., policices: [:create_user]}}
  """

  defmacro defbitfield(module, enums) do
    if !Code.ensure_loaded?(Ecto.Type),
      do: raise(CompileError, message: "Ecto.Type must be loaded before you can use EctoBitfield")

    quote do
      list = unquote(enums) |> Macro.escape()

      list =
        if Keyword.keyword?(list) do
          list
        else
          list
          |> Enum.with_index()
          |> Enum.map(fn {field, index} ->
            {field, round(:math.pow(2, index))}
          end)
        end

      defmodule Module.concat(__MODULE__, unquote(module)) do
        use Bitwise
        @behaviour Ecto.Type
        @list list
        @field_map for {field, bit} <- list, into: %{}, do: {field, bit}
        @max_bit_size Map.values(@field_map) |> Enum.sum()

        def type, do: :integer

        def cast(bit) when is_integer(bit) and bit >= 0 and bit <= @max_bit_size, do: {:ok, bit}

        def cast(fields) when is_list(fields) do
          casted_fields =
            Enum.map(fields, fn
              bit when is_integer(bit) and bit <= @max_bit_size ->
                bit

              field when is_binary(field) ->
                Map.fetch(@field_map, String.to_existing_atom(field))

              field when is_atom(field) ->
                Map.fetch(@field_map, field)

              _ ->
                :error
            end)

          if :error not in casted_fields do
            value =
              Enum.reduce(casted_fields, 0, fn {:ok, bit}, acc ->
                acc ||| bit
              end)

            {:ok, value}
          else
            :error
          end
        end

        def cast(_), do: :error

        def load(current_bit)
            when is_integer(current_bit) and current_bit >= 0 and current_bit <= @max_bit_size do
          value =
            for {field, bit} <- @list, (current_bit &&& bit) != 0 do
              field
            end

          {:ok, value}
        end

        def load(_), do: :error

        def dump(bit) when is_integer(bit) and bit >= 0 and bit <= @max_bit_size, do: {:ok, bit}
        def dump(_), do: :error

        def __meta__(:max_bit_size), do: @max_bit_size
        def __meta__(:field_map), do: @field_map
        def __meta__(:list), do: @list
        def __meta__(_), do: :error
      end
    end
  end
end
