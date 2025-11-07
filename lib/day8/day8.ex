defmodule Day8 do
  def get_input(is_example) do
    ReadInput.read_lines(is_example, 8)
    |> Enum.with_index()
    |> Enum.map(fn {line, row_idx} ->
      {Enum.with_index(String.to_charlist(line)), row_idx}
    end)
    |> Enum.reduce(Map.new(), fn {day_list, row_idx}, acc ->
      Enum.reduce(day_list, acc, fn {ch, col_idx}, acc ->
        if ch != 46 do
          pos_list = Map.get(acc, ch, [])
          Map.put(acc, ch, [{row_idx, col_idx} | pos_list])
        else
          acc
        end
      end)
    end)
  end

  def calc_anti_nodes({r1, c1}, {r2, c2}) do
    dx = c2 - c1
    dy = r2 - r1
    ar1 = r1 + 2 * dy
    ac1 = c1 + 2 * dx
    ar2 = r2 - 2 * dy
    ac2 = c2 - 2 * dx
    [{ar1, ac1}, {ar2, ac2}]
  end

  def solve_part1(is_example) do
    input = get_input(is_example)

    all_anti_nodes =
      Enum.reduce(input, [], fn {ch, pos_list}, all_an_acc ->
        pairs = Comparer.compare_all_unique_pairs(pos_list)
        IO.puts("#{ch} - ")

        anti_nodes_for_name =
          Enum.reduce(pairs, [], fn {{r1, c1}, {r2, c2}}, an_acc ->
            antinodes = calc_anti_nodes({r1, c1}, {r2, c2})

            an_acc ++ antinodes
          end)

        IO.inspect(anti_nodes_for_name, label: "antinodes for #{ch}")
        all_an_acc ++ anti_nodes_for_name
      end)

    all_anti_nodes
  end
end
