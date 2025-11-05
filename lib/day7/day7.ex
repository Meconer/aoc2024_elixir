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

  defmodule CalculatorP2 do
    defp possible_results([a, b]) do
      concat =
        (Integer.to_string(b) <> Integer.to_string(a))
        |> String.to_integer()

      [a + b, a * b, concat]
    end

    defp possible_results([a | rest]) do
      prev_results = possible_results(rest)

      Enum.flat_map(prev_results, fn el ->
        concat =
          (Integer.to_string(el) <> Integer.to_string(a))
          |> String.to_integer()

        [a + el, a * el, concat]
      end)
    end

    def calc_all(terms) do
      rev_terms = Enum.reverse(terms)
      possible_results(rev_terms)
    end
  end

  def is_valid({wanted, terms}) do
    Calculator.calc_all(terms)
    |> Enum.any?(fn res_el -> res_el == wanted end)
  end

  def solve_part1(is_example) do
    input = parse_input(is_example)

    Enum.reduce(input, 0, fn {wanted, _} = line, acc ->
      if is_valid(line), do: acc + wanted, else: acc
    end)
  end

  def is_validP2({wanted, terms}) do
    CalculatorP2.calc_all(terms)
    |> Enum.any?(fn res_el -> res_el == wanted end)
  end

  def solve_part2(is_example) do
    input = parse_input(is_example)

    Enum.reduce(input, 0, fn {wanted, _} = line, acc ->
      if is_validP2(line), do: acc + wanted, else: acc
    end)
  end
end
