# PgRanges

PostgreSQL range types for Ecto.

PgRanges provides a simple wrapper around `Postgrex.Range` so that you can
create scheams with range type fields and use the native range type in
migrations.

```elixir
defmodule MyApp.Employee do
  use Ecto.Schema
  alias PgRanges.DateRange

  schema "employees" do
    field :name, :string
    field :employed_dates, DateRange
  end
end

defmodule MyApp.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :name, :string
      add :employed_dates, :daterange
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
    {:pg_ranges, "~> 0.1.0"}
  ]
end
```
