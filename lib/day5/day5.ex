defmodule Day5 do
  def solve_part1(is_example) do
    [a, b] =
      ReadInput.read_input(is_example, 5)
      |> String.split("\n\n", trim: true)

    a =
      String.split(a, "\n", trim: true)
      |> Enum.map(&String.split(&1, "|", trim: true))
      |> Enum.map(fn [left, right] ->
        left_words = String.to_integer(left)
        right_words = String.to_integer(right)
        {left_words, right_words}
      end)

    b =
      String.split(b, "\n", trim: true)
      |> Enum.map(&String.split(&1, ",", trim: true))
      |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)

    {a, b}
  end
end
