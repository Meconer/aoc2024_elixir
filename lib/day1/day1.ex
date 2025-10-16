defmodule Day1 do
  def solve_part1(filename) do
    input = read_input(filename)

    pairs =
      input
      |> Enum.map(fn line -> String.split(line) end)
      |> Enum.map(fn [a, b] -> [String.to_integer(a), String.to_integer(b)] end)

    list1 = Enum.map(pairs, fn [a, _b] -> a end) |> Enum.sort()
    list2 = Enum.map(pairs, fn [_a, b] -> b end) |> Enum.sort()

    Enum.zip(list1, list2)
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def solve_part2(filename) do
    input = read_input(filename)

    pairs =
      input
      |> Enum.map(fn line -> String.split(line) end)
      |> Enum.map(fn [a, b] -> [String.to_integer(a), String.to_integer(b)] end)

    list1 = Enum.map(pairs, fn [a, _b] -> a end)
    list2 = Enum.map(pairs, fn [_a, b] -> b end)

    counts =
      Enum.map(list1, fn a ->
        Enum.count(list2, fn b -> b == a end)
      end)

    Enum.zip(list1, counts)
    |> Enum.map(fn {a, c} -> a * c end)
    |> Enum.sum()
  end
end
