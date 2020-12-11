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
  def type, do: :daterange
end
