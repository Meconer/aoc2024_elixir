defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  @tag day1: true
  describe("Day1 tests") do
    test "Test example part 1" do
      assert Day1.solve_part1("example.txt") == 11
    end

    test "Test example part 2" do
      assert Day1.solve_part2("example.txt") == 31
    end
  end
end
