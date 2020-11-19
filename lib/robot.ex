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

      iex> Robot.move("FFLFRFF", %Robot{position: {0, 2}, direction: :north}, %Grid{size: {4, 8}})
      %Robot{position: {-1, 6}, direction: :north}

  """
  @spec move(String.t(), Robot.t(), Grid.t()) :: Robot.t()
  def move(<<"F"::utf8, tail::binary>>, robot, grid) do
    %Robot{position: new_position, direction: direction} = change_position(robot, "F", grid)

    move(tail, %Robot{position: new_position, direction: direction}, grid)
  end

  def move(<<"L"::utf8, tail::binary>>, robot, grid) do
    %Robot{position: position, direction: new_direction} = change_direction(robot, "L")

    move(tail, %Robot{position: position, direction: new_direction}, grid)
  end

  def move(<<"R"::utf8, tail::binary>>, robot, grid) do
    %Robot{position: position, direction: new_direction} = change_direction(robot, "R")

    move(tail, %Robot{position: position, direction: new_direction}, grid)
  end

  def move("", robot, _grid), do: robot

  defp change_position(%Robot{position: {x, y}, direction: :north} = robot, "F", %Grid{
         size: {grid_x, grid_y}
       })
       when x <= grid_x and y <= grid_y,
       do: %Robot{robot | position: {x, y + 1}}

  defp change_position(%Robot{position: {x, y}, direction: :east} = robot, "F", %Grid{
         size: {grid_x, grid_y}
       })
       when x <= grid_x and y <= grid_y,
       do: %Robot{robot | position: {x + 1, y}}

  defp change_position(%Robot{position: {x, y}, direction: :south} = robot, "F", %Grid{
         size: {grid_x, grid_y}
       })
       when x <= grid_x and y <= grid_y,
       do: %Robot{robot | position: {x, y - 1}}

  defp change_position(%Robot{position: {x, y}, direction: :west} = robot, "F", %Grid{
         size: {grid_x, grid_y}
       })
       when x <= grid_x and y <= grid_y,
       do: %Robot{robot | position: {x - 1, y}}

  defp change_position(robot, _current_instruction, _grid),
    do: %Robot{robot | direction: {robot.direction, "LOST"}}

  defp change_direction(%Robot{direction: :north} = robot, "L"),
    do: %Robot{robot | direction: :west}

  defp change_direction(%Robot{direction: :north} = robot, "R"),
    do: %Robot{robot | direction: :east}

  defp change_direction(%Robot{direction: :east} = robot, "L"),
    do: %Robot{robot | direction: :north}

  defp change_direction(%Robot{direction: :east} = robot, "R"),
    do: %Robot{robot | direction: :south}

  defp change_direction(%Robot{direction: :south} = robot, "L"),
    do: %Robot{robot | direction: :east}

  defp change_direction(%Robot{direction: :south} = robot, "R"),
    do: %Robot{robot | direction: :west}

  defp change_direction(%Robot{direction: :west} = robot, "R"),
    do: %Robot{robot | direction: :north}

  defp change_direction(%Robot{direction: :west} = robot, "L"),
    do: %Robot{robot | direction: :south}
end
