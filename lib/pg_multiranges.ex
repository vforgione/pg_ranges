defmodule PgMultiranges do
  @moduledoc """
  PgMultiranges provides a simple wrapper around `Postgrex.Multirange`.
  The behaviour is an extension of `PgRanges`, with each multi type implemented
  as a list of the base type. For example, `PgRanges.Int4Multirange` takes a list of
  `PgRanges.Int4Range` structs as its constructor argument.
  """

  @callback new([map()]) :: any
  @callback new([{any, any, any}]) :: any
  @callback from_postgrex(any) :: any
  @callback to_postgrex(any) :: any

  @optional_callbacks [
    new: 1,
    from_postgrex: 1,
    to_postgrex: 1
  ]

  @doc false

  defmacro __using__(opts) do
    subtype = opts[:subtype]

    if subtype == nil do
      raise ArgumentError, "#{inspect(__MODULE__)} must be used with the :subtype option"
    end

    subtype_opts = Keyword.drop(opts, [:subtype])

    quote location: :keep, bind_quoted: [subtype: subtype, opts: subtype_opts] do
      alias Postgrex.Multirange

      use Ecto.Type
      @behaviour PgMultiranges
      @before_compile PgRanges

      @type t :: %__MODULE__{ranges: [unquote(subtype).t()]}

      defstruct [:ranges]

      @spec new([map()]) :: __MODULE__.t()
      def new(ranges, opts \\ []) do
        fields = Enum.map(ranges, &unquote(subtype).new(&1.lower, &1.upper, opts))
        struct!(__MODULE__, %{ranges: fields})
      end

      @doc false
      @spec from_postgrex(Multirange.t()) :: __MODULE__.t()
      def from_postgrex(%Multirange{ranges: ranges}),
        do: struct!(__MODULE__, %{ranges: Enum.map(ranges, &unquote(subtype).from_postgrex/1)})

      @doc false
      @spec to_postgrex(__MODULE__.t()) :: Multirange.t()
      def to_postgrex(%__MODULE__{ranges: ranges}),
        do: struct!(Multirange, %{ranges: Enum.map(ranges, &unquote(subtype).to_postgrex/1)})

      @doc false
      def cast(nil), do: {:ok, nil}
      def cast(%Multirange{} = range), do: {:ok, from_postgrex(range)}
      def cast(%__MODULE__{} = range), do: {:ok, range}
      def cast(_), do: :error

      @doc false
      def load(nil), do: {:ok, nil}
      def load(%Multirange{} = range), do: {:ok, from_postgrex(range)}
      def load(_), do: :error

      @doc false
      def dump(nil), do: {:ok, nil}
      def dump(%__MODULE__{} = range), do: {:ok, to_postgrex(range)}
      def dump(_), do: :error

      @doc false
    end
  end
end
