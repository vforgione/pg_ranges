defmodule PgRanges.TstzMultirange do
  use PgMultiranges, subtype: PgRanges.TstzRange

  @impl true
  @spec type() :: :tstzmultirange
  def type, do: :tstzmultirange
end
