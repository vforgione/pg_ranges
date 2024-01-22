defmodule PgRanges.DateMultirange do
  use PgMultiranges, subtype: PgRanges.DateRange

  @impl true
  @spec type() :: :datemultirange
  def type, do: :datemultirange
end
