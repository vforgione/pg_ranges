defmodule PgRanges.Int8Multirange do
  use PgMultiranges, subtype: PgRanges.Int8Range

  @impl true
  @spec type() :: :int8multirange
  def type, do: :int8multirange
end
