defmodule PgRanges.Int4RangeTest do
  use ExUnit.Case, async: true
  alias PgRanges.Int4Range

  defmodule Schema do
    use Ecto.Schema

    embedded_schema do
      field(:my_int4range, PgRanges.Int4Range)
    end
  end

  describe "new/3" do
    test "creates a Int4Range" do
      assert %Int4Range{r: %Postgrex.Range{lower: 10, upper: 20}} = Int4Range.new(10, 20)
    end

    test "when lower is nil" do
      assert %Int4Range{r: %Postgrex.Range{lower: nil, upper: 20}} = Int4Range.new(nil, 20)
    end

    test "when upper is nil" do
      assert %Int4Range{r: %Postgrex.Range{lower: 10, upper: nil}} = Int4Range.new(10, nil)
    end

    test "default lower_inclusive" do
      assert %Int4Range{r: %Postgrex.Range{lower: 10, upper: nil, lower_inclusive: true}} =
               Int4Range.new(10, nil)
    end

    test "lower_inclusive" do
      assert %Int4Range{r: %Postgrex.Range{lower: 10, upper: nil, lower_inclusive: true}} =
               Int4Range.new(10, nil, lower_inclusive: true)
    end

    test "default upper_inclusive" do
      assert %Int4Range{r: %Postgrex.Range{lower: 10, upper: nil, upper_inclusive: false}} =
               Int4Range.new(10, nil)
    end

    test "upper_inclusive" do
      assert %Int4Range{r: %Postgrex.Range{lower: 10, upper: nil, upper_inclusive: true}} =
               Int4Range.new(10, nil, upper_inclusive: true)
    end

    test "when lower is not a valid int4" do
      assert_raise ArgumentError, "lower expect to be int4, got: \"toto\"", fn ->
        Int4Range.new("toto", 20)
      end
    end

    test "when upper is not a valid int4" do
      assert_raise ArgumentError, "upper expect to be int4, got: \"toto\"", fn ->
        Int4Range.new(20, "toto")
      end
    end
  end

  describe "cast/1" do
    test "with nil" do
      assert {:ok, nil} = PgRanges.Int4Range.cast(nil)
    end

    test "with Postgrex.Range" do
      postgrex_range = %Postgrex.Range{lower: 10, upper: 20}

      assert PgRanges.Int4Range.cast(postgrex_range) ==
               {:ok, %PgRanges.Int4Range{r: postgrex_range}}
    end

    test "with PgRanges.Int4Range" do
      assert {:ok, %PgRanges.Int4Range{}} = PgRanges.Int4Range.cast(%PgRanges.Int4Range{})
    end

    test "with an invalid value" do
      assert PgRanges.Int4Range.cast(12) == :error
    end
  end

  describe "dump/1" do
    test "with nil" do
      assert {:ok, nil} = PgRanges.Int4Range.dump(nil)
    end

    test "with PgRanges.Int4Range" do
      postgrex_range = %Postgrex.Range{lower: 10, upper: 20}

      assert PgRanges.Int4Range.dump(%PgRanges.Int4Range{r: postgrex_range}) ==
               {:ok, postgrex_range}
    end

    test "with an invalid value" do
      assert PgRanges.Int4Range.dump(12) == :error
    end
  end

  describe "load/1" do
    test "with nil" do
      assert {:ok, nil} = PgRanges.Int4Range.load(nil)
    end

    test "with Postgrex.Range" do
      postgrex_range = %Postgrex.Range{lower: 10, upper: 20}

      assert PgRanges.Int4Range.load(postgrex_range) ==
               {:ok, %PgRanges.Int4Range{r: postgrex_range}}
    end

    test "with an invalid value" do
      assert PgRanges.Int4Range.load(12) == :error
    end
  end
end
