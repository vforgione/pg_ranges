# PgRanges

PostgreSQL range types for Ecto.

PgRanges provides a simple wrapper around `Postgrex.Range` so that you can
create schemas with range type fields and use the native range type in
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
    {:pg_ranges, "~> 1.1.1"}
  ]
end
```

## Dev Setup

While trying to not be prescriptive about how to work on this package, I
recommend using [VSCode](https://code.visualstudio.com) with the 
[Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
and [ElixirLS](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls)
extensions. The `.gitignore` file ignores `.devcontainer/` and `.vscode/`
directories, so feel free to use whatever you deem necessary.

<details>
<summary>Basic Dev Container Setup</summary>

**.devcontainer/Dockerfile**:

```dockerfile
FROM elixir:1.16
WORKDIR /workspace
```

**.devcontainer/docker-compose.yaml**:

```yaml
version: '3'
services:
  db:
    image: postgres
    restart: unless-stopped
    environment:
    - POSTGRES_USER=pgranges
    - POSTGRES_PASSWORD=pgranges
  code:
    build:
      context: ..
      dockerfile: .devcontainer/Dockerfile
    command: sleep infinity
    volumes:
    - ..:/workspace:cached
    depends_on:
    - db
```

**.devcontainer/devcontainer.json**:

```json
{
  "name": "pg_range",
  "dockerComposeFile": "docker-compose.yaml",
  "service": "code",
  "workspaceFolder": "/workspace"
}
```

</details>

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
