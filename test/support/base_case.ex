defmodule PgRanges.BaseCase do
  use ExUnit.CaseTemplate

  alias PgRanges.Repo

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PgRanges.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PgRanges.Repo, {:shared, self()})
    end

    Ecto.Adapters.SQL.query!(Repo, """
    DROP TABLE IF EXISTS models ;
    """)

    Ecto.Adapters.SQL.query!(Repo, """
    CREATE TABLE models (
      id    SERIAL    PRIMARY KEY,
      date  daterange DEFAULT NULL,
      ts    tsrange   DEFAULT NULL,
      tstz  tstzrange DEFAULT NULL,
      int4  int4range DEFAULT NULL,
      int8  int8range DEFAULT NULL,
      num   numrange  DEFAULT NULL,

      datemulti datemultirange DEFAULT NULL,
      tsmulti   tsmultirange   DEFAULT NULL,
      tstzmulti tstzmultirange DEFAULT NULL,
      int4multi int4multirange DEFAULT NULL,
      int8multi int8multirange DEFAULT NULL,
      nummulti  nummultirange  DEFAULT NULL
    ) ;
    """)

    :ok
  end
end
