defmodule Day6 do
  def find_in_grid(grid, ch_to_find) do
    grid_as_lists =
      Tuple.to_list(grid)
      |> Enum.map(&Tuple.to_list/1)

    Enum.find_index(grid_as_lists, fn row ->
      col =
        Enum.find_index(row, fn c ->
          c == ch_to_find
        end)

      col
    end)
  end

  def solve_part1(is_example) do
    {grid, width, height} = ReadInput.read_grid(is_example, 6)
    {r, c} = find_in_grid(grid, ?^)
    # GridFunc.get_char(1, 2, grid)
  end
end
