defmodule PgRanges.Int4Multirange do
  use PgMultiranges, subtype: PgRanges.Int4Range

  @impl true
  @spec type() :: :int4multirange
  def type, do: :int4multirange
end
