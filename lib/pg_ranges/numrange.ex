defmodule PgRanges.NumRange do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `numrange` type.
  """
  use PgRanges

  @type t :: %__MODULE__{
          lower: float(),
          lower_inclusive: boolean(),
          upper: float(),
          upper_inclusive: boolean()
        }

  @doc false
  def type, do: :numrange
end
