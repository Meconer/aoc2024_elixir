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
    defp possible_results([]) do
      raise("Need at least one element")
    end

    defp possible_results([el]) do
      [el]
    end

    defp possible_results([a, b], _acc) do
      [a + b, a * b]
    end

    defp possible_results([a | rest], acc) do
      results =
        Enum.flat_map(acc, fn el -> [el * a, el + a] end)

      results ++ acc
    end

    def calc_all(terms) do
      rev_terms = Enum.reverse(terms)
      IO.inspect(rev_terms)
      possible_results(rev_terms, [])
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
