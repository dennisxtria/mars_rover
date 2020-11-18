defmodule Grid do
  @moduledoc """
  Defines the `Grid` item.
  """

  defstruct size: {0, 0}

  @type t :: %__MODULE__{size: {non_neg_integer, non_neg_integer}}

  @doc ~S"""
  Asks for user input in order to get the grid size.

  ## Examples

      iex> Grid.get_size("4 5\n")
      [4, 5]

  """
  @spec get_size(IO.chardata() | IO.nodata()) :: [non_neg_integer]
  def get_size(input) do
    input
    |> String.trim()
    |> String.split("")
    |> Enum.filter(fn x -> x not in ["", " "] end)
    |> Enum.map(&String.to_integer/1)
  end

  @doc ~S"""
  Creates a new Grid struct with given size (x, y).

  ## Examples

      iex> Grid.create(4, 5)
      %Grid{size: {4, 5}}

  """
  @spec create(non_neg_integer, non_neg_integer) :: t()
  def create(x, y), do: %__MODULE__{size: {x, y}}
end
