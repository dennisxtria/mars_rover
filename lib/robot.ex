defmodule Robot do
  @moduledoc """
  Defines the `Robot` item.
  """

  alias Grid

  @directions %{"N" => :north, "E" => :east, "S" => :south, "W" => :west}

  defstruct position: {0, 0}, direction: :east

  @type t :: %__MODULE__{
          position: {non_neg_integer, non_neg_integer},
          direction: atom | {atom, String.t()}
        }

  @doc ~S"""
  Processes user input in order to prepare the starting point and
  direction for the robot.

  ## Examples

      iex> Robot.process("(0, 2, N) FFLFRFF")
      ["0", "2", "N", "FFLFRFF"]

  """
  @spec process(IO.chardata() | IO.nodata()) :: [String.t()]
  def process(input) do
    input
    |> String.split(["(", ",", ")", " "])
    |> Enum.filter(&(&1 != ""))
  end

  @doc ~S"""
  Creates a new Robot struct with given starting point and directions.

  ## Examples

      iex> Robot.create(0, 2, "N")
      %Robot{position: {0, 2}, direction: :north}

  """
  @spec create(non_neg_integer, non_neg_integer, String.t()) :: t()
  def create(x, y, direction) do
    %__MODULE__{position: {x, y}, direction: @directions[direction]}
  end

  @doc ~S"""
  Validates the Robot's starting point taking into consideration the grid size.

  ## Examples

      iex> Robot.valid_robot_point?(0, 2, %Grid{size: {4, 5}})
      true

  """
  @spec valid_robot_point?(non_neg_integer, non_neg_integer, Grid.t()) :: boolean
  def valid_robot_point?(robot_x, robot_y, %Grid{size: {grid_x, grid_y}})
      when robot_x <= grid_x and robot_y <= grid_y,
      do: true

  def valid_robot_point?(_robot_x, _robot_y, _grid), do: false

  @doc ~S"""
  Validates the given instructions.

  ## Examples

      iex> Robot.valid_instructions?("FFLFRFF")
      true

  """
  @spec valid_instructions?(String.t()) :: boolean
  def valid_instructions?(<<head::binary-size(1), tail::binary>>),
    do: head in ["F", "L", "R"] and valid_instructions?(tail)

  def valid_instructions?(""), do: true
  def valid_instructions?(_), do: false

  @doc ~S"""
  Moves the newly created robot following the given instructions.

  ## Examples

      iex> Robot.move("FFLFRFF", {0, 2}, :north, %Grid{size: {4, 8}})
      %Robot{position: {-1, 6}, direction: :north}

  """
  @spec move(String.t(), {non_neg_integer, non_neg_integer}, atom, Grid.t()) :: Robot.t()
  def move(<<"F"::utf8, tail::binary>>, robot_position, robot_direction, grid) do
    %Robot{position: new_position, direction: direction} =
      change_position(robot_position, robot_direction, "F", grid)

    move(tail, new_position, direction, grid)
  end

  def move(<<"L"::utf8, tail::binary>>, robot_position, robot_direction, grid) do
    %Robot{position: position, direction: new_direction} =
      change_direction(robot_position, robot_direction, "L")

    move(tail, position, new_direction, grid)
  end

  def move(<<"R"::utf8, tail::binary>>, robot_position, robot_direction, grid) do
    %Robot{position: position, direction: new_direction} =
      change_direction(robot_position, robot_direction, "R")

    move(tail, position, new_direction, grid)
  end

  def move("", position, direction, _grid), do: %Robot{position: position, direction: direction}

  defp change_position({x, y}, :north, "F", %Grid{size: {grid_x, grid_y}})
       when x <= grid_x and y <= grid_y,
       do: %Robot{position: {x, y + 1}, direction: :north}

  defp change_position({x, y}, :east, "F", %Grid{size: {grid_x, grid_y}})
       when x <= grid_x and y <= grid_y,
       do: %Robot{position: {x + 1, y}, direction: :east}

  defp change_position({x, y}, :south, "F", %Grid{size: {grid_x, grid_y}})
       when x <= grid_x and y <= grid_y,
       do: %Robot{position: {x, y - 1}, direction: :south}

  defp change_position({x, y}, :west, "F", %Grid{size: {grid_x, grid_y}})
       when x <= grid_x and y <= grid_y,
       do: %Robot{position: {x - 1, y}, direction: :west}

  defp change_position({x, y}, direction, _current_instruction, _grid),
    do: %Robot{position: {x, y}, direction: {direction, "LOST"}}

  defp change_direction({x, y}, :north, "L"), do: %Robot{position: {x, y}, direction: :west}
  defp change_direction({x, y}, :north, "R"), do: %Robot{position: {x, y}, direction: :east}
  defp change_direction({x, y}, :east, "L"), do: %Robot{position: {x, y}, direction: :north}
  defp change_direction({x, y}, :east, "R"), do: %Robot{position: {x, y}, direction: :south}
  defp change_direction({x, y}, :south, "L"), do: %Robot{position: {x, y}, direction: :east}
  defp change_direction({x, y}, :south, "R"), do: %Robot{position: {x, y}, direction: :west}
  defp change_direction({x, y}, :west, "R"), do: %Robot{position: {x, y}, direction: :north}
  defp change_direction({x, y}, :west, "L"), do: %Robot{position: {x, y}, direction: :south}
end
