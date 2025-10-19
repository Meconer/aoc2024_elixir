defmodule Day3 do
  def solve_part1(is_example) do
    input = ReadInput.read_input(is_example, 3)
    regex = ~r/mul\((\d+),(\d+)\)/
    matches = Regex.scan(regex, input)

    Enum.map(matches, fn [_full_match, t1s, t2s] ->
      t1 = String.to_integer(t1s)
      t2 = String.to_integer(t2s)
      t1 * t2
    end)
    |> Enum.sum()
  end
end
