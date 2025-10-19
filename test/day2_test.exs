defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "Test example part 1" do
    assert Day2.solve_part1(true) == 2
  end

  test "Test example part 2" do
    assert Day2.solve_part2(true) == 4
  end
end
