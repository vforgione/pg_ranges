defmodule PgRanges.MixProject do
  use Mix.Project

  def project do
    [
      app: :pg_ranges,
      version: "1.1.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),

      # docs
      name: "PgRanges",
      description: description(),
      source_url: "https://github.com/vforgione/pg_ranges",
      docs: [
        main: "PgRanges"
      ],
      package: package()
    ]
  end

  def application do
    if Mix.env() == :test do
      [
        mod: {PgRanges.Application, []},
        extra_applications: [:logger]
      ]
    else
      [
        extra_applications: [:logger]
      ]
    end
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto_sql, "~> 3.11"},
      {:decimal, "~> 2.1"},

      # dev/test deps
      {:tzdata, "~> 1.1", only: [:dev, :test]},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "test"]
    ]
  end

  defp description do
    """
    PostgreSQL range types for Ecto

    PgRanges provides a simple wrapper around `Postgrex.Range` so that you can
    create schemas with range type fields and use the native range type in
    migrations.
    """
  end

  defp package,
    do: [
      files: ["lib", "mix.exs", "COPYING", "LICENSE"],
      maintainers: ["Vince Forgione"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/vforgione/pg_ranges"
      }
    ]
end
