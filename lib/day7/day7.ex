defmodule Day7 do
  def parse_input(is_example) do
    input =
      ReadInput.read_input(is_example, 7)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ": ", trim: true))
      |> Enum.map(fn [left, right] ->
        left = String.to_integer(left)

        right =
          String.split(right, " ", trim: true)
          |> Enum.map(&String.to_integer/1)

        {left, right}
      end)

    input
  end

  defp calc(t1, t2, :plus), do: t1 + t2
  defp calc(t1, t2, :times), do: t1 * t2

  def calc_possible_results({wanted, terms}) do
    IO.puts("W: #{wanted}")
    Enum.chunk_every(terms, 2, 1, :discard)
  end

  def solve_part1(is_example) do
    input = parse_input(is_example)

    Enum.map(input, fn line -> calc_possible_results(line) end)
  end
end
