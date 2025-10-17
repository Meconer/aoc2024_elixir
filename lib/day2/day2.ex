defmodule Day2 do
  def makediffs(list) do
    list
    |> Enum.zip(tl(list))
    |> Enum.map(fn {a, b} -> b - a end)
  end

  def valid_incr(diff), do: diff >= 1 && diff <= 3
  def valid_decr(diff), do: diff >= -3 && diff <= -1

  def is_valid(line) do
    diffs =
      String.split(line)
      |> Enum.map(&String.to_integer/1)
      |> makediffs()

    is_valid_incr = Enum.all?(diffs, fn d -> valid_incr(d) end)
    is_valid_decr = Enum.all?(diffs, fn d -> valid_decr(d) end)

    is_valid_decr || is_valid_incr
  end

  def solve_part1(is_example) do
    lines =
      ReadInput.read_lines(is_example, 2)

    Enum.count(lines, fn line -> is_valid(line) end)
  end

  def solve_part2(is_example) do
    lines = ReadInput.read_lines(is_example, 2)

    for line <- lines do
      IO.puts(line)
    end
  end
end
