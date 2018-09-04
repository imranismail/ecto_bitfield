defmodule EctoBitfieldTest do
  use ExUnit.Case
  doctest EctoBitfield

  import EctoBitfield

  defbitfield ValidDays, [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

  test "type" do
    assert :integer = EctoBitfieldTest.ValidDays.type()
  end

  test "cast/1" do
    max_bit_size = EctoBitfieldTest.ValidDays.__meta__(:max_bit_size)
    possible_fields = EctoBitfieldTest.ValidDays.__meta__(:list) |> Keyword.keys()

    assert {:ok, 1} = EctoBitfieldTest.ValidDays.cast([:sunday])
    assert {:ok, ^max_bit_size} = EctoBitfieldTest.ValidDays.cast(possible_fields)
    assert :error = EctoBitfieldTest.ValidDays.cast(max_bit_size + 1)
  end

  test "load/1" do
    max_bit_size = EctoBitfieldTest.ValidDays.__meta__(:max_bit_size)
    possible_fields = EctoBitfieldTest.ValidDays.__meta__(:list) |> Keyword.keys()

    assert {:ok, [:sunday]} = EctoBitfieldTest.ValidDays.load(1)
    assert {:ok, ^possible_fields} = EctoBitfieldTest.ValidDays.load(max_bit_size)
    assert :error = EctoBitfieldTest.ValidDays.load(max_bit_size + 1)
  end

  test "dump/1" do
    max_bit_size = EctoBitfieldTest.ValidDays.__meta__(:max_bit_size)

    assert {:ok, 1} = EctoBitfieldTest.ValidDays.dump(1)
    assert {:ok, ^max_bit_size} = EctoBitfieldTest.ValidDays.dump(max_bit_size)
    assert :error = EctoBitfieldTest.ValidDays.dump(max_bit_size + 1)
  end
end
