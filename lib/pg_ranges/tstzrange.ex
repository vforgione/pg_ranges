defmodule PgRanges.TstzRange do
  @moduledoc """
  Wraps a `Postgrex.Range` and casts to a PostgreSQL `tstzrange` type.
  """
  defstruct r: nil

  @type t :: %__MODULE__{r: Postgrex.Range.t()}

  @doc """
  Creates a new `PgRanges.TstzRange` struct. It expects the _lower_ and _upper_
  attributes to be `DateTime`s.

  This will convert the date time structs to UTC time.

  ## Options

  - `lower_inclusive`: should the range be lower inclusive? Default is `true`
  - `upper_inclusive`: should the range be upper inclusive? Default is `false`
  """
  @spec new(DateTime.t(), DateTime.t(), keyword()) :: PgRanges.TstzRange.t()
  def new(lower, upper, opts \\ []) do
    lower = Timex.to_datetime(lower, "Etc/UTC")
    upper = Timex.to_datetime(upper, "Etc/UTC")

    fields =
      [lower_inclusive: true, upper_inclusive: false]
      |> Keyword.merge(opts)
      |> Keyword.merge([lower: lower, upper: upper])

    %PgRanges.TstzRange{r: struct!(Postgrex.Range, fields)}
  end

  @doc false
  @spec from_postgrex(Postgrex.Range.t()) :: PgRanges.TstzRange.t()
  def from_postgrex(%Postgrex.Range{} = r), do: %PgRanges.TstzRange{r: r}

  @doc false
  @spec to_postgrex(PgRanges.TstzRange.t()) :: Postgrex.Range.t()
  def to_postgrex(%PgRanges.TstzRange{r: r}), do: r

  @behaviour Ecto.Type

  @doc false
  def type, do: :tstzrange

  @doc false
  def cast(nil), do: {:ok, nil}
  def cast(%Postgrex.Range{} = r), do: {:ok, from_postgrex(r)}
  def cast(%PgRanges.TstzRange{} = r), do: {:ok, r}
  def cast(_), do: :error

  @doc false
  def load(nil), do: {:ok, nil}
  def load(%Postgrex.Range{} = r), do: {:ok, from_postgrex(r)}
  def load(_), do: :error

  @doc false
  def dump(nil), do: {:ok, nil}
  def dump(%PgRanges.TstzRange{} = r), do: {:ok, to_postgrex(r)}
  def dump(_), do: :error
end
