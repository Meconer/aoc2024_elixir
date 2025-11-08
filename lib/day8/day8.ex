defmodule Day8 do
  def parse_input(is_example) do
    lines = ReadInput.read_lines(is_example, 8)
    width = String.length(List.first(lines))
    heigth = length(lines)

    # Find every position that has an antenna
    # and return a map with antenna name as key
    # and a list of positions {r,c} as value
    parsed =
      lines
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

    {parsed, width, heigth}
  end

  @doc """
  Finds the antinodes for part 1.
  """
  def calc_anti_nodes({r1, c1}, {r2, c2}) do
    dx = c2 - c1
    dy = r2 - r1
    ar1 = r1 + 2 * dy
    ac1 = c1 + 2 * dx
    ar2 = r2 - 2 * dy
    ac2 = c2 - 2 * dx
    [{ar1, ac1}, {ar2, ac2}]
  end

  @doc """
  For part 2, get the antinodes that is on equal distance from a pair of antennas.
  Call this with two antenna positions, the distance between them, a factor of 1
  and the size of the grid. This function will call itself with the factor increasing
  by 1 until the antinode positions are all outside the grid range.
  """
  def get_antinodes_in_range({r1, c1}, {r2, c2}, {dx, dy}, factor, {width, height}, accum) do
    pr1 = r1 + factor * dy
    pc1 = c1 + factor * dx
    nr2 = r2 - factor * dy
    nc2 = c2 - factor * dx

    positions =
      [{pr1, pc1}, {nr2, nc2}]
      |> Enum.filter(fn {r, c} -> is_on_grid({r, c}, {width, height}) end)

    if length(positions) == 0 do
      accum
    else
      get_antinodes_in_range(
        {r1, c1},
        {r2, c2},
        {dx, dy},
        factor + 1,
        {width, height},
        accum ++ positions
      )
    end
  end

  @doc """
  Part 2 only
  Calculates all antinodes by calling the recursive function above
  """
  def calc_anti_nodes_p2({r1, c1}, {r2, c2}, {width, height}) do
    dx = c2 - c1
    dy = r2 - r1

    factor = 1

    antinodes_in_range =
      get_antinodes_in_range({r1, c1}, {r2, c2}, {dx, dy}, factor, {width, height}, [])

    antinodes_in_range
  end

  @doc """
  Calculates antinodes for p1
  """
  def calc_all_anti_nodes_p1(input) do
    # Find the antinodes for each antenna name
    all_anti_nodes =
      Enum.reduce(input, [], fn {_ch, pos_list}, all_an_acc ->
        # Get all combos of two antennas (with same name)
        pairs = Comparer.compare_all_unique_pairs(pos_list)

        # Get the antinodes for each pair
        anti_nodes_for_name =
          Enum.reduce(pairs, [], fn {{r1, c1}, {r2, c2}}, an_acc ->
            antinodes = calc_anti_nodes({r1, c1}, {r2, c2})

            an_acc ++ antinodes
          end)

        all_an_acc ++ anti_nodes_for_name
      end)

    all_anti_nodes
  end

  @doc """
  Calculates antinodes for p1
  """
  def calc_all_anti_nodes_p2(input, width, height) do
    all_anti_nodes =
      Enum.reduce(input, [], fn {_ch, pos_list}, all_an_acc ->
        pairs = Comparer.compare_all_unique_pairs(pos_list)

        anti_nodes_for_name =
          Enum.reduce(pairs, [], fn {{r1, c1}, {r2, c2}}, an_acc ->
            antinodes = calc_anti_nodes_p2({r1, c1}, {r2, c2}, {width, height})

            an_acc ++ antinodes
          end)

        all_an_acc ++ anti_nodes_for_name
      end)

    all_anti_nodes
  end

  @doc """
  Checks if a position is on the grid
  """
  def is_on_grid({r, c}, {width, height}) do
    r >= 0 and r < height and c >= 0 and c < width
  end

  def solve_part1(is_example) do
    {input, width, height} = parse_input(is_example)

    calc_all_anti_nodes_p1(input)
    |> Enum.filter(fn {r, c} -> is_on_grid({r, c}, {width, height}) end)
    # Put the positions in  a map to filter out duplicates
    |> MapSet.new()
    |> MapSet.size()
  end

  def solve_part2(is_example) do
    {input, width, height} = parse_input(is_example)

    calc_all_anti_nodes_p2(input, width, height)
    # Put the positions in  a map to filter out duplicates
    |> MapSet.new()
    |> MapSet.size()
  end
end
