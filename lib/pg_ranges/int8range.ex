defmodule PgRanges.Int8Range do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `int8range` type.
  """
  use PgRanges

  @type t :: %__MODULE__{
          lower: integer() | :unbound | :empty,
          lower_inclusive: boolean(),
          upper: integer() | :unbound | :empty,
          upper_inclusive: boolean()
        }

  @doc false
  @spec type() :: :int8range
  def type, do: :int8range
end
