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

  def traverse_p2(grid, width, height, pos, dir, visited) do
    # GridFunc.print_tuple_grid(grid, pos, dir)
    # IO.gets("Ent")

    case pos do
      {r, c} when r < 0 or c < 0 or r >= height or c >= width ->
        {visited, false}

      pos ->
        precheck = GridFunc.get_char(move_forward(pos, dir), grid)

        if MapSet.member?(visited, {pos, dir}) do
          # We have been here before in this direction - looping
          {visited, true}
        end

        visited = MapSet.put(visited, {pos, dir})

        cond do
          precheck == "#" or precheck == "O" ->
            new_dir = turn_right(dir)
            new_pos = move_forward(pos, new_dir)
            traverse_p2(grid, width, height, new_pos, new_dir, visited)

          precheck == "" ->
            {visited, false}

          true ->
            new_pos = move_forward(pos, dir)
            traverse_p2(grid, width, height, new_pos, dir, visited)
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

  def p2_solver(grid, width, height, {s_r, s_c} = start_pos, obstacle_pos, looping_positions) do
    {o_r, o_c} = obstacle_pos

    IO.puts("Testing obstacle at #{inspect(obstacle_pos)}")
    IO.puts("Looping positions so far: #{inspect(looping_positions)}")
    IO.puts("Start pos: #{inspect(start_pos)}")

    if o_r == s_r and o_c == s_c do
      IO.puts("Skipping start pos #{inspect(obstacle_pos)}")
      p2_solver(grid, width, height, start_pos, {o_r, o_c + 1}, looping_positions)
    end

    if o_r >= height, do: looping_positions

    if o_c >= width do
      p2_solver(grid, width, height, start_pos, {o_r + 1, 0}, looping_positions)
    else
      test_grid = GridFunc.set_char(grid, obstacle_pos, ?#)
      GridFunc.print_tuple_grid(test_grid)
      IO.gets("Next grid")
      visited = MapSet.new()

      {_visited, loop} =
        traverse_p2(test_grid, width, height, start_pos, :north, visited)

      if loop do
        IO.puts("Loop detected at obstacle #{inspect(obstacle_pos)}")

        ^looping_positions =
          MapSet.put(looping_positions, obstacle_pos)
      end

      p2_solver(grid, width, height, start_pos, {o_r, o_c + 1}, looping_positions)
    end
  end

  def solve_part2(is_example) do
    {grid, width, height} = ReadInput.read_grid(is_example, 6)

    startpos = GridFunc.find_in_grid(grid, ?^)
    grid = GridFunc.set_char(grid, startpos, ?.)
    p2_solver(grid, width, height, startpos, {0, 0}, MapSet.new())
  end
end
