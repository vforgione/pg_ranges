defmodule PgRanges.Int8Range do
  @moduledoc """
  """

  defstruct r: nil

  @type t :: %__MODULE__{r: Postgrex.Range.t()}

  @doc ""
  @spec new(integer(), integer(), keyword()) :: PgRanges.Int8Range.t()
  def new(lower, upper, opts \\ []) do
    fields =
      [lower_inclusive: true, upper_inclusive: false]
      |> Keyword.merge(opts)
      |> Keyword.merge([lower: lower, upper: upper])

    %PgRanges.Int8Range{r: struct!(Postgrex.Range, fields)}
  end

  @doc ""
  @spec from_postgrex(Postgrex.Range.t()) :: PgRanges.Int8Range.t()
  def from_postgrex(%Postgrex.Range{} = r), do: %PgRanges.Int8Range{r: r}

  @doc ""
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
