defmodule PgRanges.BaseCase do
  use ExUnit.CaseTemplate

  alias PgRanges.TestRepo

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PgRanges.TestRepo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PgRanges.TestRepo, {:shared, self()})
    end

    Ecto.Adapters.SQL.query!(TestRepo, """
    DROP TABLE IF EXISTS models ;
    """)

    Ecto.Adapters.SQL.query!(TestRepo, """
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
