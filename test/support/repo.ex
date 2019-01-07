defmodule PgRanges.Repo do
  use Ecto.Repo,
    otp_app: :pg_ranges,
    adapter: Ecto.Adapters.Postgres
end
