defmodule Day6 do
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
    # GridFunc.print_tuple_grid(grid, pos, dir)
    # IO.gets("Ent")

    case pos do
      {r, c} when r < 0 or c < 0 or r >= height or c >= width ->
        visited

      pos ->
        precheck = GridFunc.get_char(move_forward(pos, dir), grid)

        visited = MapSet.put(visited, {pos})

        cond do
          precheck == "#" or precheck == "O" ->
            new_dir = turn_right(dir)
            new_pos = move_forward(pos, new_dir)
            traverse(grid, width, height, new_pos, new_dir, visited)

          precheck == "" ->
            visited

          true ->
            new_pos = move_forward(pos, dir)
            traverse(grid, width, height, new_pos, dir, visited)
        end
    end
  end

  def solve_part1(is_example) do
    {grid, width, height} = ReadInput.read_grid(is_example, 6)

    startpos = GridFunc.find_in_grid(grid, ?^)
    grid = GridFunc.set_char(grid, startpos, ?.)
    startdir = :north
    visited = MapSet.new()
    visited = traverse(grid, width, height, startpos, startdir, visited)
    visited
  end

  def p2_solver(grid, width, height, obstacle_pos, looping_positions) do
    {o_r, o_c} = obstacle_pos
    if o_r > height, do: looping_positions

    grid = GridFunc.set_char(grid, obstacle_pos, ?#)
  end

  def solve_part2(is_example) do
    {grid, width, height} = ReadInput.read_grid(is_example, 6)

    startpos = GridFunc.find_in_grid(grid, ?^)
    grid = GridFunc.set_char(grid, startpos, ?.)
    startdir = :north
    visited = MapSet.new()
    visited = traverse(grid, width, height, startpos, startdir, visited)
    visited
  end
end
