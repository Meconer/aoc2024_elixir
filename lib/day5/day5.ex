defmodule Day5 do
  def solve_part1(is_example) do
    [a,b]  = ReadInput.read_input( is_example, 5)
    |> String.split("\n\n", trim: true)
    a = String.split(a, "\n", trim: true)
    |> Enum.map(&String.split(&1, "|", trim: true))

    b = String.split(b, "\n", trim: true)
    |> Enum.map(&String.split(&1, ",", trim: true))
    {a,b}
  end
end
