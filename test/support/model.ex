defmodule PgRanges.Model do
  use Ecto.Schema

  import Ecto.Changeset

  schema "models" do
    field :date, PgRanges.DateRange, default: nil
    field :ts, PgRanges.TsRange, default: nil
    field :tstz, PgRanges.TstzRange, default: nil
    field :int4, PgRanges.Int4Range, default: nil
    field :int8, PgRanges.Int8Range, default: nil
    field :num, PgRanges.NumRange, default: nil
  end

  @attrs ~w| date ts tstz int4 int8 num |a

  @doc false
  def changeset(model, params) do
    model
    |> cast(params, @attrs)
  end
end
