defmodule RobotTest do
  @moduledoc false

  use ExUnit.Case, async: true

  doctest Robot

  @grid %Grid{size: {4, 5}}

  describe "robot process functionality" do
    test "correct user input gets split successfully" do
      assert Robot.process("(2, 3, E) LFRFF") == ["2", "3", "E", "LFRFF"]
    end

    test "user input not so well formatted gets split successfully" do
      assert Robot.process("(2,3, ELFRFF") == ["2", "3", "ELFRFF"]
    end
  end

  describe "robot creation functionality" do
    test "creates robot struct with north direction defined" do
      assert Robot.create(6, 8, "N") == %Robot{position: {6, 8}, direction: :north}
    end

    test "creates robot struct with east direction defined" do
      assert Robot.create(2, 7, "E") == %Robot{position: {2, 7}, direction: :east}
    end
  end

  describe "robot valid starting point functionality" do
    test "robot with starting point within grid" do
      assert Robot.valid_robot_point?(2, 3, @grid) == true
    end

    test "robot with starting point without grid" do
      assert Robot.valid_robot_point?(6, 8, @grid) == false
    end
  end

  describe "robot valid instructions functionality" do
    test "creates robot struct with north direction defined" do
      assert Robot.valid_instructions?("LFRFF") == true
    end

    test "creates robot struct with east direction defined" do
      assert Robot.valid_instructions?("FRAHLFER") == false
    end
  end

  describe "robot move functionality" do
    test "moves within grid size" do
      assert Robot.move("LFRFF", %Robot{position: {2, 3}, direction: :east}, %Grid{size: {4, 8}}) ==
               %Robot{
                 position: {4, 4},
                 direction: :east
               }
    end

    test "moves without grid size functionality and gets lost" do
      assert Robot.move("FFLFRFF", %Robot{position: {2, 3}, direction: :east}, %Grid{size: {4, 8}}) ==
               %Robot{
                 position: {5, 4},
                 direction: {:east, "LOST"}
               }
    end
  end
end
