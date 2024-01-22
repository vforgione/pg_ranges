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
    NumRange,
    DateMultirange,
    TsMultirange,
    TstzMultirange,
    Int4Multirange,
    Int8Multirange,
    NumMultirange
  }

  setup do
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

    now = DateTime.utc_now()

    date_multi = DateMultirange.new([date_range, DateRange.new(~D[2018-04-23], ~D[2018-04-24])])

    ts_multi =
      TsMultirange.new([ts_range, TsRange.new(~N[2018-04-23 15:00:00], ~N[2018-04-24 01:00:00])])

    tstz_multirange =
      TstzMultirange.new([
        TstzRange.new(now, DateTime.add(now, 1, :hour)),
        TstzRange.new(DateTime.add(now, 2, :hour), DateTime.add(now, 3, :hour))
      ])

    int4_multi = Int4Multirange.new([int4_range, Int4Range.new(11, 20)])
    int8_multi = Int8Multirange.new([int8_range, Int8Range.new(1_000_000_001, 2_000_000_000)])
    num_multi = NumMultirange.new([num_range, NumRange.new(10.0, 19.9, upper_inclusive: true)])

    {:ok, m} =
      Model.changeset(%Model{}, %{
        date: date_range,
        ts: ts_range,
        tstz: tstz_range,
        int4: int4_range,
        int8: int8_range,
        num: num_range,
        datemulti: date_multi,
        tsmulti: ts_multi,
        tstzmulti: tstz_multirange,
        int4multi: int4_multi,
        int8multi: int8_multi,
        nummulti: num_multi
      })
      |> Repo.insert()

    {:ok, model: m, now: now}
  end

  test "querying" do
    range = Int4Range.new(1, 4)

    models =
      Repo.all(from(m in Model, where: fragment("? @> ?", m.int4, type(^range, Int4Range))))

    assert length(models) == 1
  end

  test "querying tstzrange" do
    tzdb = Calendar.get_time_zone_database()

    inside =
      DateTime.from_naive!(~N[2018-04-21 15:30:00], "America/Chicago")
      |> DateTime.shift_zone!("Etc/UTC", tzdb)

    outside =
      DateTime.from_naive!(~N[2018-04-21 14:30:00], "America/Chicago")
      |> DateTime.shift_zone!("Etc/UTC", tzdb)

    models =
      Repo.all(
        from(m in Model, where: fragment("? @> ?::timestamp with time zone", m.tstz, ^inside))
      )

    assert length(models) == 1

    models =
      Repo.all(
        from(m in Model, where: fragment("? @> ?::timestamp with time zone", m.tstz, ^outside))
      )

    assert length(models) == 0
  end

  test "querying tstzmultirange", %{now: now} do
    inside1 = DateTime.add(now, 30, :minute)
    inside2 = DateTime.add(now, 150, :minute)
    outside = DateTime.add(now, 500, :minute)

    models =
      Repo.all(
        from(m in Model,
          where: fragment("? @> ?::timestamp with time zone", m.tstzmulti, ^inside1)
        )
      )

    assert length(models) == 1

    models =
      Repo.all(
        from(m in Model,
          where: fragment("? @> ?::timestamp with time zone", m.tstzmulti, ^inside2)
        )
      )

    assert length(models) == 1

    models =
      Repo.all(
        from(m in Model,
          where: fragment("? @> ?::timestamp with time zone", m.tstzmulti, ^outside)
        )
      )

    assert length(models) == 0
  end
end
