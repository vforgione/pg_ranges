import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :pg_ranges, PgRanges.Repo,
  username: "pgranges",
  password: "pgranges",
  database: "pgranges",
  hostname: "localhost",
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox

config :pg_ranges, ecto_repos: [PgRanges.Repo]

config :logger, level: :warning
