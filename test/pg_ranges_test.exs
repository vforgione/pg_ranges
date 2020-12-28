defmodule PgRanges.PgRangesTest do
  use PgRanges.BaseCase

  import Ecto.Query

  alias PgRanges.{
    TestRepo,
    Model,
    DateRange,
    TsRange,
    TstzRange,
    Int4Range,
    Int8Range,
    NumRange
  }

  setup do
    date_range = DateRange.new(~D[2018-04-21], ~D[2018-04-22])
    ts_range = TsRange.new(~N[2018-04-21 15:00:00], ~N[2018-04-22 01:00:00])

    {:ok, tz_datetime_1} =
      ~N[2018-04-21 15:00:00]
      |> DateTime.from_naive("America/Chicago", Tzdata.TimeZoneDatabase)

    {:ok, tz_datetime_2} =
      ~N[2018-04-22 01:00:00]
      |> DateTime.from_naive("America/Chicago", Tzdata.TimeZoneDatabase)

    tstz_range = TstzRange.new(tz_datetime_1, tz_datetime_2)
    int4_range = Int4Range.new(0, 10)
    int8_range = Int8Range.new(0, 1_000_000_000)
    num_range = NumRange.new(0, 9.9, upper_inclusive: true)

    {:ok, m} =
      Model.changeset(%Model{}, %{
        date: date_range,
        ts: ts_range,
        tstz: tstz_range,
        int4: int4_range,
        int8: int8_range,
        num: num_range
      })
      |> TestRepo.insert()

    {:ok, model: m}
  end

  test "querying" do
    range = Int4Range.new(1, 4)

    models =
      TestRepo.all(from(m in Model, where: fragment("? @> ?", m.int4, type(^range, Int4Range))))

    assert length(models) == 1
  end
end
