defmodule PgRanges.TsRange do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `tsrange` type.
  """
  use PgRanges

  @type t :: %__MODULE__{
          lower: NaiveDateTime.t(),
          lower_inclusive: boolean(),
          upper: NaiveDateTime.t(),
          upper_inclusive: boolean()
        }

  @doc false
  @impl true
  @spec type() :: :tsrange
  def type, do: :tsrange

  @impl true
  def equal?(%__MODULE__{} = left, %__MODULE__{} = right) do
    DateTime.compare(left.lower, right.lower) == :eq and
      left.lower_inclusive == right.lower_inclusive and
      DateTime.compare(left.upper, right.upper) == :eq and
      left.upper_inclusive == right.upper_inclusive
  end

  def equal?(_, _), do: false
end
