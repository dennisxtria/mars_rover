defmodule MarsRover do
  @moduledoc """
  This module implements the entire Mars Rover operation.
  """

  @external_resource "lib/input.txt"
  @input "lib/input.txt"

  @doc false
  @spec start :: :ok
  def start do
    processed_input =
      @input
      |> File.read!()
      |> String.split("\r\n")

    [grid | robots] = processed_input

    [grid_x, grid_y] = Grid.get_size(grid)

    grid = Grid.create(grid_x, grid_y)

    Enum.each(robots, &start_robot(&1, grid))
  end

  defp start_robot(robot_input, grid) do
    [x, y, direction, instructions] = Robot.process(robot_input)

    robot_x = String.to_integer(x)
    robot_y = String.to_integer(y)

    with true <- Robot.valid_robot_point?(robot_x, robot_y, grid),
         true <- Robot.valid_instructions?(instructions) do
      robot = Robot.create(robot_x, robot_y, direction)

      %Robot{position: {x, y}, direction: direction} = Robot.move(instructions, robot, grid)

      IO.puts("(#{x}, #{y}, #{inspect(direction)})")
    else
      false -> {:error, :invalid_user_input}
    end
  end
end
