defmodule PgRanges.DateRange do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `daterange` type.
  """
  use PgRanges

  @type t :: %__MODULE__{
          lower: Date.t(),
          lower_inclusive: integer(),
          upper: Date.t(),
          upper_inclusive: integer()
        }

  @doc false
  @impl true
  @spec type() :: :daterange
  def type, do: :daterange

  @impl true
  def equal?(%__MODULE__{} = left, %__MODULE__{} = right) do
    Date.compare(left.lower, right.lower) == :eq and
      left.lower_inclusive == right.lower_inclusive and
      Date.compare(left.upper, right.upper) == :eq and
      left.upper_inclusive == right.upper_inclusive
  end
end
