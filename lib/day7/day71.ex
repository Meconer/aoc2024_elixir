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

  defmodule Calculator do
    defp possible_results([a, b]) do
      [a + b, a * b]
    end

    defp possible_results([a | rest]) do
      prev_results = possible_results(rest)

      Enum.flat_map(prev_results, fn el -> [a + el, a * el] end)
    end

    def calc_all(terms) do
      rev_terms = Enum.reverse(terms)
      possible_results(rev_terms)
    end
  end

  def calc_possible_results({wanted, terms}) do
    IO.puts("W: #{wanted}")
    Calculator.calc_all(terms)
  end

  def solve_part1(is_example) do
    input = parse_input(is_example)

    Enum.map(input, fn line -> calc_possible_results(line) end)
  end
end
