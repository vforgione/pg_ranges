defmodule PgRanges.TsMultirange do
  use PgMultiranges, subtype: PgRanges.TsRange

  @impl true
  @spec type() :: :tsmultirange
  def type, do: :tsmultirange
end
