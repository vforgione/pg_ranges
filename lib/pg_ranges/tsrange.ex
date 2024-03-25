defmodule PgRanges.TsRange do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `tsrange` type.
  """
  use PgRanges

  @type t :: %__MODULE__{
          lower: NaiveDateTime.t() | :unbound | :empty,
          lower_inclusive: boolean(),
          upper: NaiveDateTime.t() | :unbound | :empty,
          upper_inclusive: boolean()
        }

  @doc false
  @spec type() :: :tsrange
  def type, do: :tsrange
end
