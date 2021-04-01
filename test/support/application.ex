defmodule PgRanges.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      PgRanges.Repo
    ]

    opts = [strategy: :one_for_one, name: PgRanges.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
