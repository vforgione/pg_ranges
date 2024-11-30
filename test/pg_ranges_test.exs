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

  setup tags do
    if tags[:setup_test_model] do
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
    else
      :ok
    end
  end

  @tag :setup_test_model
  test "querying" do
    range = Int4Range.new(1, 4)

    models =
      Repo.all(from(m in Model, where: fragment("? @> ?", m.int4, type(^range, Int4Range))))

    assert length(models) == 1
  end

  @tag :setup_test_model
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

  @tag :setup_test_model
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

  test "can handle lower and upper open ended ranges" do
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

  test "can handle lower open ended ranges" do
    date_range = DateRange.new(~D[2018-04-21], :unbound)
    ts_range = TsRange.new(~N[2018-04-21 15:00:00.000000], :unbound)
    tstz_range = TstzRange.new(~U[2018-04-21 20:00:00.000000Z], :unbound)

    int4_range = Int4Range.new(0, :unbound)
    int8_range = Int8Range.new(0, :unbound)
    num_range = NumRange.new(0, :unbound)

    assert {:ok, _model} =
             Model.changeset(%Model{}, %{
               date: date_range,
               ts: ts_range,
               tstz: tstz_range,
               int4: int4_range,
               int8: int8_range,
               num: num_range
             })
             |> Repo.insert()

    assert %Model{
             date: ^date_range,
             ts: ^ts_range,
             tstz: ^tstz_range,
             int4: ^int4_range,
             int8: ^int8_range,
             num: ^num_range
           } = Repo.one(Model)
  end

  test "can handle upper open ended ranges" do
    date_range = DateRange.new(:unbound, ~D[2018-04-21], lower_inclusive: false)
    ts_range = TsRange.new(:unbound, ~N[2018-04-21 15:00:00.000000], lower_inclusive: false)
    tstz_range = TstzRange.new(:unbound, ~U[2018-04-21 20:00:00.000000Z], lower_inclusive: false)
    int4_range = Int4Range.new(:unbound, 0, lower_inclusive: false)
    int8_range = Int8Range.new(:unbound, 0, lower_inclusive: false)
    num_range = NumRange.new(:unbound, 0, lower_inclusive: false)

    assert {:ok, _model} =
             Model.changeset(%Model{}, %{
               date: date_range,
               ts: ts_range,
               tstz: tstz_range,
               int4: int4_range,
               int8: int8_range,
               num: num_range
             })
             |> Repo.insert()

    assert %Model{
             date: ^date_range,
             ts: ^ts_range,
             tstz: ^tstz_range,
             int4: ^int4_range,
             int8: ^int8_range,
             num: ^num_range
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
end
