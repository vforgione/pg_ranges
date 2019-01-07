defmodule PgRanges.TstzRange do
  @moduledoc """
  """

  defstruct r: nil

  @type t :: %__MODULE__{r: Postgrex.Range.t()}

  @doc ""
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

  @doc ""
  @spec from_postgrex(Postgrex.Range.t()) :: PgRanges.TstzRange.t()
  def from_postgrex(%Postgrex.Range{} = r), do: %PgRanges.TstzRange{r: r}

  @doc ""
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
