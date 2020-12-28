import Mix.Config

# config :pg_ranges, timezone_database: Tzdata.TimeZoneDatabase

if Mix.env() == :test do
  config :pg_ranges, ecto_repos: [PgRanges.TestRepo]

  config :pg_ranges, PgRanges.TestRepo,
    username: System.get_env("DB_USER"),
    password: System.get_env("DB_PASSWORD"),
    database: System.get_env("DB_DATABASE"),
    hostname: System.get_env("DB_HOST"),
    pool_size: 10,
    pool: Ecto.Adapters.SQL.Sandbox

  config :logger, level: :warn
end
