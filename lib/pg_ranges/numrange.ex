defmodule PgRanges.NumRange do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `numrange` type.
  """
  use PgRanges

  @type t :: %__MODULE__{
          lower: float(),
          lower_inclusive: boolean(),
          upper: float(),
          upper_inclusive: boolean()
        }

  @doc false
  @impl true
  def type, do: :numrange

  @doc false
  @impl true
  @spec from_postgrex(Range.t()) :: __MODULE__.t()
  def from_postgrex(
        %Range{
          lower: %Decimal{},
          upper: %Decimal{}
        } = range
      ) do
    struct!(__MODULE__, Map.from_struct(range))
  end

  @impl true
  @spec from_postgrex(Range.t()) :: __MODULE__.t()
  def from_postgrex(
        %Range{
          lower: lower,
          upper: upper
        } = range
      ) do
    fields =
      range |> Map.from_struct() |> Map.merge(lower: to_decimal(lower), upper: to_decimal(upper))

    struct!(__MODULE__, fields)
  end

  @doc false
  @impl true
  @spec to_postgrex(__MODULE__.t()) :: Range.t()
  def to_postgrex(
        %__MODULE__{
          lower: %Decimal{},
          upper: %Decimal{}
        } = range
      ),
      do: struct!(Range, Map.from_struct(range))

  def to_postgrex(
        %__MODULE__{
          lower: lower,
          upper: upper
        } = range
      ) do
    fields =
      range |> Map.from_struct() |> Map.merge(lower: to_decimal(lower), upper: to_decimal(upper))

    struct!(Range, fields)
  end

  @doc """
  Creates a new `#{__MODULE__}` struct. It expects the _lower_ and _upper_
  attributes to be acceptable by `Decimal.new/1`.
  This will convert tany acceptable input to Decimal.
  ## Options
  - `lower_inclusive`: should the range be lower inclusive? Default is `true`
  - `upper_inclusive`: should the range be upper inclusive? Default is `false`
  """
  @spec new(DateTime.t(), DateTime.t(), keyword()) :: __MODULE__.t()
  @impl true
  def new(lower, upper, opts \\ []) do
    fields = Keyword.merge(opts, lower: to_decimal(lower), upper: to_decimal(upper))

    struct!(__MODULE__, fields)
  end

  defp to_decimal(value) when is_float(value), do: Decimal.from_float(value)
  defp to_decimal(value), do: Decimal.new(value)
end
