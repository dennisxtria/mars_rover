defmodule GridTest do
  @moduledoc false

  use ExUnit.Case, async: true

  doctest Grid

  describe "grid size functionality" do
    test "gets grid size successfully (dimensions seperated with space)" do
      assert Grid.get_size("5 3\n") == [5, 3]
    end

    test "gets grid size successfully (dimensions seperated without space)" do
      assert Grid.get_size("45\n") == [4, 5]
    end
  end

  describe "grid creation functionality" do
    test "creates grid struct with all keys defined" do
      assert Grid.create(5, 3) == %Grid{size: {5, 3}}
    end
  end
end
