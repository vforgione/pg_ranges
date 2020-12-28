ExUnit.start()

PgRanges.TestRepo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(PgRanges.TestRepo, :manual)
