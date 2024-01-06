defmodule PgRanges.NumRangesTest do
  use PgRanges.BaseCase

  import Ecto.Query

  alias PgRanges.Model
  alias PgRanges.NumRange
  alias PgRanges.Repo

  setup do
    range = NumRange.new(0, 9.9, upper_inclusive: true)

    {:ok, m} =
      Model.changeset(%Model{}, %{
        num: range
      })
      |> Repo.insert()

    {:ok, model: m, range: range}
  end

  test "querying", %{model: %{id: model_id}, range: original_range} do
    ranges = [
      NumRange.new(1, 4.3),
      NumRange.new(1, Decimal.from_float(4.3)),
      NumRange.new(1, Decimal.new("4.3"))
      # TODO: research and add support for infinity
      # NumRange.new(Decimal.new("-Infinity"), Decimal.new("Infinity"))
    ]

    Enum.each(ranges, fn range ->
      assert %{upper: %Decimal{}, lower: %Decimal{}} = range

      assert [%{id: ^model_id, num: ^original_range}] =
               Repo.all(
                 from(m in Model, where: fragment("? @> ?", m.num, type(^range, NumRange)))
               )
    end)
  end
end
