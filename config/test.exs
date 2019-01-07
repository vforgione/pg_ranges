use Mix.Config

config :pg_ranges, PgRanges.Repo,
  username: "pgranges",
  password: "pgranges",
  database: "pgranges",
  hostname: "localhost",
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox

config :pg_ranges, ecto_repos: [PgRanges.Repo]

config :logger, level: :warn
