defmodule PgRanges.TestRepo do
  use Ecto.Repo,
    otp_app: :pg_ranges,
    adapter: Ecto.Adapters.Postgres
end
