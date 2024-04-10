defmodule PgRanges.NumMultirange do
  use PgMultiranges, subtype: PgRanges.NumRange

  @impl true
  @spec type() :: :nummultirange
  def type, do: :nummultirange
end
