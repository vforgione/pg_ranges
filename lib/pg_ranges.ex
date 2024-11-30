defmodule PgRanges do
  @moduledoc """
  PgRanges provides a simple wrapper around `Postgrex.Range` so that you can
  create schemas with range type fields and use the native range type in
  migrations.

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

  When used in composing queries, you must cast to the PgRange type.

      import Ecto.Query
      alias PgRanges.DateRange
      alias MyApp.Repo

      range = DateRange.new(~D[2018-11-01], ~D[2019-01-01])

      Repo.all(
        from e in Employee,
        where: fragment("? @> ?", e.employed_dates, type(^range, DateRange))
      )
  """

  @callback new(lower :: any, upper :: any) :: any
  @callback new(any, any, any) :: any
  @callback from_postgrex(any) :: any
  @callback to_postgrex(any) :: any

  @optional_callbacks new: 2,
                      new: 3,
                      from_postgrex: 1,
                      to_postgrex: 1

  @doc false
  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      alias Postgrex.Range

      use Ecto.Type
      @behaviour PgRanges
      @before_compile PgRanges

      defstruct lower: :unbound,
                lower_inclusive: false,
                upper: :unbound,
                upper_inclusive: false

      @spec new(any, any, keyword()) :: __MODULE__.t()
      def new(lower, upper, opts \\ []) do
        lower = calculate_value(lower)
        upper = calculate_value(upper)
        lower_inclusive = calculate_inclusive(lower, Keyword.get(opts, :lower_inclusive))
        upper_inclusive = calculate_inclusive(upper, Keyword.get(opts, :upper_inclusive))

        fields = [
          lower: lower,
          upper: upper,
          lower_inclusive: lower_inclusive,
          upper_inclusive: upper_inclusive
        ]

        struct!(__MODULE__, fields)
      end

      def calculate_inclusive(value, inclusive?)
      def calculate_inclusive(nil, nil), do: false
      def calculate_inclusive(:unbound, nil), do: false
      def calculate_inclusive(:empty, nil), do: false
      def calculate_inclusive(_, nil), do: true
      def calculate_inclusive(_, inclusive?), do: inclusive?

      def calculate_value(nil), do: :unbound
      def calculate_value(value), do: value

      @doc false
      @spec from_postgrex(Range.t()) :: __MODULE__.t()
      def from_postgrex(%Range{} = range),
        do: struct!(__MODULE__, Map.from_struct(range))

      @doc false
      @spec to_postgrex(__MODULE__.t()) :: Range.t()
      def to_postgrex(%__MODULE__{} = range), do: struct!(Range, Map.from_struct(range))

      @doc false
      def cast(nil), do: {:ok, nil}
      def cast(%Range{} = range), do: {:ok, from_postgrex(range)}
      def cast(%__MODULE__{} = range), do: {:ok, range}
      def cast(_), do: :error

      @doc false
      def load(nil), do: {:ok, nil}
      def load(%Range{} = range), do: {:ok, from_postgrex(range)}
      def load(_), do: :error

      @doc false
      def dump(nil), do: {:ok, nil}
      def dump(%__MODULE__{} = range), do: {:ok, to_postgrex(range)}
      def dump(_), do: :error

      defoverridable new: 2,
                     new: 3,
                     from_postgrex: 1,
                     to_postgrex: 1
    end
  end

  @doc false
  defmacro __before_compile__(env) do
    unless Module.defines?(env.module, {:type, 0}) do
      message = """
      function type/0 required by behaviour Ecto.Type is not implemented \
      (in module #{inspect(env.module)}).
      """

      IO.warn(message, Macro.Env.stacktrace(env))

      quote do
        @doc false
        def type, do: :not_a_valid_type
      end
    end
  end
end
