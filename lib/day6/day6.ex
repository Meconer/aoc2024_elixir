defmodule Day6 do
  def solve_part1(is_example) do
    {grid, width, height} = ReadInput.read_grid(is_example, 6)
    grid
    # GridFunc.get_char(1, 2, grid)
  end
end
