defmodule PgRanges.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      %{
        id: PgRanges.Repo,
        start: {PgRanges.Repo, :start_link, []}
      }
    ]

    opts = [strategy: :one_for_one, name: PgRanges.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
