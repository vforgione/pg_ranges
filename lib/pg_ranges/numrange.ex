defmodule PgRanges.NumRange do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `numrange` type.
  """
  defstruct r: nil

  @type t :: %__MODULE__{r: Postgrex.Range.t()}

  @doc """
  Creates a new `PgRanges.NumRange` struct. It expects the _lower_ and _upper_
  attributes to be floats.

  ## Options

  - `lower_inclusive`: should the range be lower inclusive? Default is `true`
  - `upper_inclusive`: should the range be upper inclusive? Default is `false`
  """
  @spec new(float(), float(), keyword()) :: PgRanges.NumRange.t()
  def new(lower, upper, opts \\ []) do
    fields =
      [lower_inclusive: true, upper_inclusive: false]
      |> Keyword.merge(opts)
      |> Keyword.merge([lower: lower, upper: upper])

    %PgRanges.NumRange{r: struct!(Postgrex.Range, fields)}
  end

  @doc false
  @spec from_postgrex(Postgrex.Range.t()) :: PgRanges.NumRange.t()
  def from_postgrex(%Postgrex.Range{} = r), do: %PgRanges.NumRange{r: r}

  @doc false
  @spec to_postgrex(PgRanges.NumRange.t()) :: Postgrex.Range.t()
  def to_postgrex(%PgRanges.NumRange{r: r}), do: r

  @behaviour Ecto.Type

  @doc false
  def type, do: :numrange

  @doc false
  def cast(nil), do: {:ok, nil}
  def cast(%Postgrex.Range{} = r), do: {:ok, from_postgrex(r)}
  def cast(%PgRanges.NumRange{} = r), do: {:ok, r}
  def cast(_), do: :error

  @doc false
  def load(nil), do: {:ok, nil}
  def load(%Postgrex.Range{} = r), do: {:ok, from_postgrex(r)}
  def load(_), do: :error

  @doc false
  def dump(nil), do: {:ok, nil}
  def dump(%PgRanges.NumRange{} = r), do: {:ok, to_postgrex(r)}
  def dump(_), do: :error
end
