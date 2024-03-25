defmodule PgRanges.PgRangesTest do
  use PgRanges.BaseCase

  import Ecto.Query

  alias PgRanges.{
    Repo,
    Model,
    DateRange,
    TsRange,
    TstzRange,
    Int4Range,
    Int8Range,
    NumRange
  }

  test "querying" do
    date_range = DateRange.new(~D[2018-04-21], ~D[2018-04-22])
    ts_range = TsRange.new(~N[2018-04-21 15:00:00], ~N[2018-04-22 01:00:00])

    tstz_range =
      TstzRange.new(
        DateTime.from_naive!(~N[2018-04-21 15:00:00], "America/Chicago"),
        DateTime.from_naive!(~N[2018-04-22 01:00:00], "America/Chicago")
      )

    int4_range = Int4Range.new(0, 10)
    int8_range = Int8Range.new(0, 1_000_000_000)
    num_range = NumRange.new(0, 9.9, upper_inclusive: true)

    {:ok, _model} =
      Model.changeset(%Model{}, %{
        date: date_range,
        ts: ts_range,
        tstz: tstz_range,
        int4: int4_range,
        int8: int8_range,
        num: num_range
      })
      |> Repo.insert()

    search_range = Int4Range.new(1, 4)

    models =
      Repo.all(
        from(m in Model, where: fragment("? @> ?", m.int4, type(^search_range, Int4Range)))
      )

    assert length(models) == 1
  end

  test "can handle open ended ranges" do
    assert {:ok, _model} =
             Model.changeset(%Model{}, %{
               date: DateRange.new(:unbound, :unbound),
               ts: TsRange.new(:unbound, :unbound),
               tstz: TstzRange.new(:unbound, :unbound),
               int4: Int4Range.new(:unbound, :unbound),
               int8: Int8Range.new(:unbound, :unbound),
               num: NumRange.new(:unbound, :unbound)
             })
             |> Repo.insert()

    assert %Model{
             date: %DateRange{lower: :unbound, upper: :unbound},
             ts: %TsRange{lower: :unbound, upper: :unbound},
             tstz: %TstzRange{lower: :unbound, upper: :unbound},
             int4: %Int4Range{lower: :unbound, upper: :unbound},
             int8: %Int8Range{lower: :unbound, upper: :unbound},
             num: %NumRange{lower: :unbound, upper: :unbound}
           } = Repo.one(Model)
  end

  test "can handle empty range" do
    assert {:ok, _model} =
             Model.changeset(%Model{}, %{
               date: DateRange.new(:empty, :empty),
               ts: TsRange.new(:empty, :empty),
               tstz: TstzRange.new(:empty, :empty),
               int4: Int4Range.new(:empty, :empty),
               int8: Int8Range.new(:empty, :empty),
               num: NumRange.new(:empty, :empty)
             })
             |> Repo.insert()

    assert %Model{
             date: %DateRange{lower: :empty, upper: :empty},
             ts: %TsRange{lower: :empty, upper: :empty},
             tstz: %TstzRange{lower: :empty, upper: :empty},
             int4: %Int4Range{lower: :empty, upper: :empty},
             int8: %Int8Range{lower: :empty, upper: :empty},
             num: %NumRange{lower: :empty, upper: :empty}
           } = Repo.one(Model)
  end
end
