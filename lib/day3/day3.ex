defmodule Day3 do
  def do_muls(s) do
    regex = ~r/mul\((\d+),(\d+)\)/
    matches = Regex.scan(regex, s)

    Enum.map(matches, fn [_full_match, t1s, t2s] ->
      t1 = String.to_integer(t1s)
      t2 = String.to_integer(t2s)
      t1 * t2
    end)
    |> Enum.sum()
  end

  def solve_part1(is_example) do
    input = ReadInput.read_input(is_example, 3)
    do_muls(input)
  end

  def remove_to_next_do(s) do
    case :binary.match(s, "do()") do
      :nomatch ->
        ""

      {index, match_length} ->
        str_len = String.length(s)
        rem_len = str_len - index - match_length
        String.slice(s, index + match_length, rem_len)
    end
  end

  def remove_donts(s) do
    case :binary.match(s, "don't()") do
      {index, match_length} ->
        str_len = String.length(s)
        rem_len = str_len - index - match_length
        rem_str_before = String.slice(s, 0, index)
        rem_str_after = remove_to_next_do(String.slice(s, index + match_length, rem_len))
        rem_str_before <> remove_donts(rem_str_after)

      :nomatch ->
        s
    end
  end

  def solve_part2(is_example) do
    input = ReadInput.read_input(is_example, 3)
    input = remove_donts(input)
    do_muls(input)
  end
end
