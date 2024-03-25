defmodule PgRanges.DateRange do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `daterange` type.
  """
  use PgRanges

  @type t :: %__MODULE__{
          lower: Date.t() | :unbound | :empty,
          lower_inclusive: integer(),
          upper: Date.t() | :unbound | :empty,
          upper_inclusive: integer()
        }

  @doc false
  @spec type() :: :daterange
  def type, do: :daterange
end
