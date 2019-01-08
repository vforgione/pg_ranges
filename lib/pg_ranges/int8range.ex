defmodule PgRanges.Int8Range do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `int8range` type.
  """
  defstruct r: nil

  @type t :: %__MODULE__{r: Postgrex.Range.t()}

  @doc """
  Creates a new `PgRanges.Int8Range` struct. It expects the _lower_ and _upper_
  attributes to be integerss.

  ## Options

  - `lower_inclusive`: should the range be lower inclusive? Default is `true`
  - `upper_inclusive`: should the range be upper inclusive? Default is `false`
  """
  @spec new(integer(), integer(), keyword()) :: PgRanges.Int8Range.t()
  def new(lower, upper, opts \\ []) do
    fields =
      [lower_inclusive: true, upper_inclusive: false]
      |> Keyword.merge(opts)
      |> Keyword.merge([lower: lower, upper: upper])

    %PgRanges.Int8Range{r: struct!(Postgrex.Range, fields)}
  end

  @doc false
  @spec from_postgrex(Postgrex.Range.t()) :: PgRanges.Int8Range.t()
  def from_postgrex(%Postgrex.Range{} = r), do: %PgRanges.Int8Range{r: r}

  @doc false
  @spec to_postgrex(PgRanges.Int8Range.t()) :: Postgrex.Range.t()
  def to_postgrex(%PgRanges.Int8Range{r: r}), do: r

  @behaviour Ecto.Type

  @doc false
  def type, do: :int8range

  @doc false
  def cast(nil), do: {:ok, nil}
  def cast(%Postgrex.Range{} = r), do: {:ok, from_postgrex(r)}
  def cast(%PgRanges.Int8Range{} = r), do: {:ok, r}
  def cast(_), do: :error

  @doc false
  def load(nil), do: {:ok, nil}
  def load(%Postgrex.Range{} = r), do: {:ok, from_postgrex(r)}
  def load(_), do: :error

  @doc false
  def dump(nil), do: {:ok, nil}
  def dump(%PgRanges.Int8Range{} = r), do: {:ok, to_postgrex(r)}
  def dump(_), do: :error
end
