defmodule PgRanges.TstzRange do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `tstzrange` type.
  """
  use PgRanges

  @type t :: %__MODULE__{
          lower: DateTime.t() | :unbound | :empty,
          lower_inclusive: boolean(),
          upper: DateTime.t() | :unbound | :empty,
          upper_inclusive: boolean()
        }

  @impl true
  @spec type() :: :tstzrange
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

    lower = shift_to_utc(lower, time_zone_database)
    upper = shift_to_utc(upper, time_zone_database)

    fields = Keyword.merge(opts, lower: lower, upper: upper)

    struct!(__MODULE__, fields)
  end

  defp shift_to_utc(date_time, time_zone_database)
  defp shift_to_utc(:unbound, _time_zone_database), do: :unbound
  defp shift_to_utc(:empty, _time_zone_database), do: :empty

  defp shift_to_utc(date_time, time_zone_database) do
    {:ok, date_time} = DateTime.shift_zone(date_time, "Etc/UTC", time_zone_database)

    date_time
  end
end
