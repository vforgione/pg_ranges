defmodule PgRanges.DateRange do
  use Ecto.Type

  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `daterange` type.
  """

  defstruct r: nil

  @type t :: %__MODULE__{r: Postgrex.Range.t()}

  @doc """
  Creates a new `PgRanges.DateRange` struct. It expects the _lower_ and _upper_
  attributes to be `Date`s.

  ## Options

  - `lower_inclusive`: should the range be lower inclusive? Default is `true`
  - `upper_inclusive`: should the range be upper inclusive? Default is `false`
  """
  @spec new(Date.t(), Date.t(), keyword()) :: PgRanges.DateRange.t()
  def new(lower, upper, opts \\ []) do
    fields =
      [lower_inclusive: true, upper_inclusive: false]
      |> Keyword.merge(opts)
      |> Keyword.merge(lower: lower, upper: upper)

    %PgRanges.DateRange{r: struct!(Postgrex.Range, fields)}
  end

  @doc false
  @spec from_postgrex(Postgrex.Range.t()) :: PgRanges.DateRange.t()
  def from_postgrex(%Postgrex.Range{} = r), do: %PgRanges.DateRange{r: r}

  @doc false
  @spec to_postgrex(PgRanges.DateRange.t()) :: Postgrex.Range.t()
  def to_postgrex(%PgRanges.DateRange{r: r}), do: r

  @doc false
  def type, do: :daterange

  @doc false
  def cast(nil), do: {:ok, nil}
  def cast(%Postgrex.Range{} = r), do: {:ok, from_postgrex(r)}
  def cast(%PgRanges.DateRange{} = r), do: {:ok, r}
  def cast(_), do: :error

  @doc false
  def load(nil), do: {:ok, nil}
  def load(%Postgrex.Range{} = r), do: {:ok, from_postgrex(r)}
  def load(_), do: :error

  @doc false
  def dump(nil), do: {:ok, nil}
  def dump(%PgRanges.DateRange{} = r), do: {:ok, to_postgrex(r)}
  def dump(_), do: :error
end
