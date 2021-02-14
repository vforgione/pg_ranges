defmodule PgRanges.TstzRange do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `tstzrange` type.
  """
  use PgRanges

  @type t :: %__MODULE__{
          lower: DateTime.t(),
          lower_inclusive: boolean(),
          upper: DateTime.t(),
          upper_inclusive: boolean()
        }

  @impl true
  def type, do: :tstzrange

  @doc """
  Creates a new `#{__MODULE__}` struct. It expects the _lower_ and _upper_
  attributes to be `DateTime`s.

  This will convert the date time structs to UTC time.

  ## Options
  - `lower_inclusive`: should the range be lower inclusive? Default is `true`
  - `upper_inclusive`: should the range be upper inclusive? Default is `false`
  """
  @spec new(DateTime.t(), DateTime.t(), keyword()) :: __MODULE__.t()
  @impl true
  def new(lower, upper, opts \\ []) do
    time_zone_database = Keyword.get(opts, :time_zone_database, Calendar.get_time_zone_database())
    {:ok, lower} = DateTime.shift_zone(lower, "Etc/UTC", time_zone_database)
    {:ok, upper} = DateTime.shift_zone(upper, "Etc/UTC", time_zone_database)

    fields = Keyword.merge(opts, lower: lower, upper: upper)

    struct!(__MODULE__, fields)
  end
end
