defmodule Day2 do
  def makediffs(list) do
    list
    |> Enum.zip(tl(list))
    |> Enum.map(fn {a, b} -> b - a end)
  end

  def valid_incr(a, b) do
    diff = b - a
    diff >= 1 && diff <= 3
  end

  def is_valid(line) do
    _numbers = String.split(line)
    true
  end

  def solve_part1(is_example) do
    lines = ReadInput.read_lines(is_example, 2)
    Enum.count(lines, fn line -> is_valid(line) end)
  end
end
