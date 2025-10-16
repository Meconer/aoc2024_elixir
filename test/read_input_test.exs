defmodule ReadInputTest do
  use ExUnit.Case
  doctest ReadInput

  test "Test read day 1 example" do
    assert ReadInput.get_file_path(true, 1) == "lib/day1/example.txt"
  end

  test "Correct no of lines read" do
    lines = ReadInput.read_lines(true, 1)
    assert length(lines) == 6
  end
end
