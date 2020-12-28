defmodule PgRanges.Int4Range do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `int4range` type.
  """
  use Ecto.Type

  @type t :: %__MODULE__{r: Postgrex.Range.t()}
  @int4_range -2_147_483_648..2_147_483_647

  defstruct r: nil

  @doc """
  Creates a new `PgRanges.Int4Range` struct. It expects the _lower_ and _upper_
  attributes to be integers.

  ## Options

  - `lower_inclusive`: should the range be lower inclusive? Default is `true`
  - `upper_inclusive`: should the range be upper inclusive? Default is `false`
  """
  @spec new(integer(), integer(), keyword()) :: PgRanges.Int4Range.t()
  def new(lower, upper, opts \\ []) do
    fields =
      [lower_inclusive: true, upper_inclusive: false]
      |> Keyword.merge(opts)
      |> Keyword.merge(lower: lower, upper: upper)

    unless valid_int4?(lower) do
      raise ArgumentError,
            "lower expect to be int4, " <> "got: #{inspect(lower)}"
    end

    unless valid_int4?(upper) do
      raise ArgumentError,
            "upper expect to be int4, " <> "got: #{inspect(upper)}"
    end

    %PgRanges.Int4Range{r: struct!(Postgrex.Range, fields)}
  end

  @doc false
  @spec from_postgrex(Postgrex.Range.t()) :: PgRanges.Int4Range.t()
  def from_postgrex(%Postgrex.Range{} = r), do: %PgRanges.Int4Range{r: r}

  @doc false
  @spec to_postgrex(PgRanges.Int4Range.t()) :: Postgrex.Range.t()
  def to_postgrex(%PgRanges.Int4Range{r: r}), do: r

  @impl true
  def type, do: :int4range

  @impl true
  def cast(nil), do: {:ok, nil}

  def cast(%Postgrex.Range{} = postgrex_range) do
    if valid_int4range?(postgrex_range) do
      {:ok, from_postgrex(postgrex_range)}
    else
      :error
    end
  end

  def cast(%PgRanges.Int4Range{} = int4range), do: {:ok, int4range}
  def cast(_), do: :error

  @impl true
  def load(nil), do: {:ok, nil}
  def load(%Postgrex.Range{} = postgrex_range), do: {:ok, from_postgrex(postgrex_range)}
  def load(_), do: :error

  @impl true
  def dump(nil), do: {:ok, nil}
  def dump(%PgRanges.Int4Range{} = int4range), do: {:ok, to_postgrex(int4range)}
  def dump(_), do: :error

  defp valid_int4range?(%Postgrex.Range{} = postgrex_range) do
    valid_int4?(postgrex_range.lower) and valid_int4?(postgrex_range.upper)
  end

  defp valid_int4range?(%Postgrex.Range{} = postgrex_range),
    do: valid_int4?(postgrex_range.lower) && valid_int4?(postgrex_range.upper)

  def valid_int4?(nil), do: true
  def valid_int4?(term), do: is_integer(term) and term in @int4_range
end
