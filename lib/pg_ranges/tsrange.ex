defmodule PgRanges.TsRange do
  use Ecto.Type

  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `tsrange` type.
  """
  defstruct r: nil

  @type t :: %__MODULE__{r: Postgrex.Range.t()}

  @doc """
  Creates a new `PgRanges.TsRange` struct. It expects the _lower_ and _upper_
  attributes to be `NaiveDateTime`s.

  ## Options

  - `lower_inclusive`: should the range be lower inclusive? Default is `true`
  - `upper_inclusive`: should the range be upper inclusive? Default is `false`
  """
  @spec new(NaiveDateTime.t(), NaiveDateTime.t(), keyword()) :: PgRanges.TsRange.t()
  def new(lower, upper, opts \\ []) do
    fields =
      [lower_inclusive: true, upper_inclusive: false]
      |> Keyword.merge(opts)
      |> Keyword.merge(lower: lower, upper: upper)

    %PgRanges.TsRange{r: struct!(Postgrex.Range, fields)}
  end

  @doc false
  @spec from_postgrex(Postgrex.Range.t()) :: PgRanges.TsRange.t()
  def from_postgrex(%Postgrex.Range{} = r), do: %PgRanges.TsRange{r: r}

  @doc false
  @spec to_postgrex(PgRanges.TsRange.t()) :: Postgrex.Range.t()
  def to_postgrex(%PgRanges.TsRange{r: r}), do: r

  @doc false
  def type, do: :tsrange

  @doc false
  def cast(nil), do: {:ok, nil}
  def cast(%Postgrex.Range{} = r), do: {:ok, from_postgrex(r)}
  def cast(%PgRanges.TsRange{} = r), do: {:ok, r}
  def cast(_), do: :error

  @doc false
  def load(nil), do: {:ok, nil}
  def load(%Postgrex.Range{} = r), do: {:ok, from_postgrex(r)}
  def load(_), do: :error

  @doc false
  def dump(nil), do: {:ok, nil}
  def dump(%PgRanges.TsRange{} = r), do: {:ok, to_postgrex(r)}
  def dump(_), do: :error
end
