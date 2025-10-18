defmodule Day2 do
  def makediffs(list) do
    list
    |> Enum.zip(tl(list))
    |> Enum.map(fn {a, b} -> b - a end)
  end

  def valid_incr(diff), do: diff >= 1 && diff <= 3
  def valid_decr(diff), do: diff >= -3 && diff <= -1

  def is_valid(list) do
    diffs = makediffs(list)

    is_valid_incr = Enum.all?(diffs, fn d -> valid_incr(d) end)
    is_valid_decr = Enum.all?(diffs, fn d -> valid_decr(d) end)

    is_valid_decr || is_valid_incr
  end

  def solve_part1(is_example) do
    lines =
      ReadInput.read_lines(is_example, 2)

    lists =
      Enum.map(lines, fn line ->
        String.split(line)
        |> Enum.map(&String.to_integer/1)
      end)

    Enum.count(lists, fn list -> is_valid(list) end)
  end

  def remove_one_at_a_time(list) do
    # Start the recursion with an empty prefix and the full list as the suffix
    do_remove_one_at_a_time([], list, [])
  end

  # Base Case: When the suffix is empty, we are done.
  defp do_remove_one_at_a_time(_prefix, [], acc), do: Enum.reverse(acc)

  # Recursive Case: Match the head and tail of the suffix
  defp do_remove_one_at_a_time(prefix, [head | tail], acc) do
    # 1. Create the new list by dropping the 'head' element:
    #    Concatenate the already-collected prefix with the remaining tail.
    new_list = Enum.reverse(prefix) ++ tail

    # 2. Continue the recursion:
    #    - Update the prefix: the 'head' is now part of the prefix.
    #    - Update the suffix: the 'tail' is the new suffix.
    #    - Update the accumulator: prepend the new_list to the accumulator (for efficiency).
    do_remove_one_at_a_time([head | prefix], tail, [new_list | acc])
  end

  def solve_part2(is_example) do
    lines = ReadInput.read_lines(is_example, 2)

    Enum.reduce(lines, 0, fn line, count ->
      list =
        String.split(line)
        |> Enum.map(fn el -> String.to_integer(el) end)

      with_one_removed = remove_one_at_a_time(list)
      valid = Enum.any?(with_one_removed, fn l -> is_valid(l) end)
      if valid, do: count + 1, else: count
    end)
  end
end
