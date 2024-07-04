# PgRanges

PostgreSQL range and multirange types for Ecto.

PgRanges provides a simple wrapper around `Postgrex.Range` and `Postrex.Multirange`
so that you can create schemas with range type fields and use the native range type in
migrations.

```elixir
defmodule MyApp.Employee do
  use Ecto.Schema
  alias PgRanges.DateRange

  schema "employees" do
    field :name, :string
    field :employed_dates, DateRange
    field :scheduled_meetings, DateMultiRange
  end
end

defmodule MyApp.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :name, :string
      add :employed_dates, :daterange
      add :scheduled_meetings, :datemultirange
    end
  end
end
```

When used in composing queries, you must cast to the PgRange type.

```elixir
import Ecto.Query
alias PgRanges.DateRange
alias MyApp.Repo

range = DateRange.new(~D[2018-11-01], ~D[2019-01-01])

Repo.all(
  from e in Employee,
  where: fragment("? @> ?", e.employed_dates, type(^range, DateRange))
)
```

## Installation

The package can be installed by adding `pg_ranges` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [
    {:pg_ranges, "~> 1.1.1"}
  ]
end
```

## Dev Setup

This repo contains a `.devcontainer` directory that should be sufficient to bootstrap a dev container. Follow your normal workflow to use it.

### Running the Tests

<details>
<summary>Local Only (Not in a Dev Container)</summary>

First, you'll need a locally running Postgres server. The easiest way to do this
is using Docker:

```shell
$ docker pull postgres
$ docker run -p 5432:5432 -e POSTGRES_USER=pgranges -e POSTGRES_PASSWORD=pgranges postgres
```

</details>

To run the tests:

```shell
$ mix test
```
