defmodule PgRanges.Int4Range do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `int4range` type.
  """
  use PgRanges

  @type t :: %__MODULE__{
          lower: integer(),
          lower_inclusive: boolean(),
          upper: integer(),
          upper_inclusive: boolean()
        }

  @doc false
  @spec type() :: :int4range
  def type, do: :int4range
end
