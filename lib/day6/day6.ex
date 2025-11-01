defmodule Day6 do
  def find_in_grid(grid, ch_to_find) do
    grid_as_lists =
      Tuple.to_list(grid)
      |> Enum.map(&Tuple.to_list/1)

    row_idx =
      Enum.with_index(grid_as_lists)
      |> Enum.find_index(fn {row, idx} ->
        Enum.member?(row, ch_to_find)
      end)

    row = :erlang.element(row_idx + 1, grid)

    col_idx =
      Enum.find_index(Tuple.to_list(row), fn ch -> ch == ch_to_find end)

    {row_idx, col_idx}
  end

  def turn_right(dir) do
    case dir do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
  end

  def move_forward({r, c}, dir) do
    case dir do
      :north -> {r - 1, c}
      :east -> {r, c + 1}
      :south -> {r + 1, c}
      :west -> {r, c - 1}
    end
  end

  def traverse(grid, width, height, pos, dir, visited) do
    case pos do
      {r, c} when r < 0 or c < 0 or r >= height or c >= width ->
        visited

      {r, c} ->
        next_pos = move_forward(pos, dir)
        precheck = GridFunc.get_char(next_pos, grid)
        ch = GridFunc.get_char(r + 1, c + 1, grid)
        visited = MapSet.put(visited, pos)

        case ch do
          "#" ->
            new_dir = turn_right(dir)
            new_pos = move_forward(pos, new_dir)
            traverse(grid, width, height, new_pos, new_dir, visited)

          _ ->
            visited = MapSet.put(visited, pos)
            new_pos = move_forward(pos, dir)
            traverse(grid, width, height, new_pos, dir, visited)
        end
    end
  end

  def solve_part1(is_example) do
    {grid, width, height} = ReadInput.read_grid(is_example, 6)
    startpos = find_in_grid(grid, ?^)
    startdir = :north
    GridFunc.print_grid(grid)
    visited = MapSet.new()
    visited = traverse(grid, width, height, startpos, startdir, visited)
    visited
  end
end
