import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :pg_ranges, PgRanges.Repo,
  username: System.get_env("POSTGRES_USERNAME", "najapi"),
  password: System.get_env("POSTGRES_PASSWORD", "passwrod"),
  database: System.get_env("POSTGRES_DATABASE", "najapi_dev"),
  hostname: System.get_env("POSTGRES_HOSTNAME", "localhost"),
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox

config :pg_ranges, ecto_repos: [PgRanges.Repo]

config :logger, level: :warning
