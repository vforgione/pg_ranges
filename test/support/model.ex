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

    field :datemulti, PgRanges.DateMultirange, default: nil
    field :tsmulti, PgRanges.TsMultirange, default: nil
    field :tstzmulti, PgRanges.TstzMultirange, default: nil
    field :int4multi, PgRanges.Int4Multirange, default: nil
    field :int8multi, PgRanges.Int8Multirange, default: nil
    field :nummulti, PgRanges.NumMultirange, default: nil
  end

  @attrs ~w| date ts tstz int4 int8 num datemulti tsmulti tstzmulti int4multi int8multi nummulti |a

  @doc false
  def changeset(model, params) do
    model
    |> cast(params, @attrs)
  end
end
