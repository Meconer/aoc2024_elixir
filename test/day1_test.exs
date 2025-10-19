defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "Test example part 1" do
    assert Day1.solve_part1(true) == 11
  end

  test "Test example part 2" do
    assert Day1.solve_part2(true) == 31
  end
end
