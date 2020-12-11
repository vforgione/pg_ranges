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
      num   numrange  DEFAULT NULL
    ) ;
    """)

    :ok
  end
end
