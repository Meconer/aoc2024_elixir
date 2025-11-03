defmodule Day6 do
  def turn_right(:north), do: :east
  def turn_right(:east), do: :south
  def turn_right(:south), do: :west
  def turn_right(:west), do: :north

  def move_forward({r, c}, :north), do: {r - 1, c}
  def move_forward({r, c}, :east), do: {r, c + 1}
  def move_forward({r, c}, :south), do: {r + 1, c}
  def move_forward({r, c}, :west), do: {r, c - 1}

  def traverse(_grid, width, height, {r, c} = _pos, _dir, visited)
      when r < 0 or c < 0 or r >= height or c >= width do
    visited
  end

  def traverse(grid, width, height, pos, dir, visited) do
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

  def solve_part1(is_example) do
    {grid, width, height} = ReadInput.read_grid(is_example, 6)

    startpos = GridFunc.find_in_grid(grid, ?^)
    grid = GridFunc.set_char(grid, startpos, ?.)
    startdir = :north
    visited = MapSet.new()
    visited = traverse(grid, width, height, startpos, startdir, visited)
    visited
  end

  def traverse_p2(grid, width, height, pos, dir, visited) do
    case pos do
      {r, c} when r < 0 or c < 0 or r >= height or c >= width ->
        {visited, false}

      pos ->
        {r, c} = pos
        precheck = GridFunc.get_char(move_forward(pos, dir), grid)

        case MapSet.member?(visited, {r, c, dir}) do
          true ->
            {visited, true}

          false ->
            visited = MapSet.put(visited, {r, c, dir})

            cond do
              precheck == "#" or precheck == "O" ->
                new_dir = turn_right(dir)
                # new_pos = move_forward(pos, new_dir)
                traverse_p2(grid, width, height, pos, new_dir, visited)

              precheck == "" ->
                {visited, false}

              true ->
                new_pos = move_forward(pos, dir)
                traverse_p2(grid, width, height, new_pos, dir, visited)
            end
        end
    end
  end

  def p2_solver(
        _grid,
        _width,
        _height,
        _start_pos,
        [],
        looping_positions
      ) do
    looping_positions
  end

  def p2_solver(
        grid,
        width,
        height,
        {s_r, s_c} = start_pos,
        [{o_r, o_c} | obstacle_positions],
        looping_positions
      )
      when o_r == s_r and o_c == s_c do
    p2_solver(grid, width, height, start_pos, obstacle_positions, looping_positions)
  end

  def p2_solver(
        grid,
        width,
        height,
        start_pos,
        [{o_r, o_c} | obstacle_positions],
        looping_positions
      ) do
    test_grid = GridFunc.set_char(grid, {o_r, o_c}, ?#)

    {_, loop} =
      traverse_p2(test_grid, width, height, start_pos, :north, MapSet.new())

    looping_positions =
      if loop do
        MapSet.put(looping_positions, {o_r, o_c})
      else
        looping_positions
      end

    p2_solver(grid, width, height, start_pos, obstacle_positions, looping_positions)
  end

  def solve_part2(is_example) do
    {grid, width, height} = ReadInput.read_grid(is_example, 6)

    startpos = GridFunc.find_in_grid(grid, ?^)
    grid = GridFunc.set_char(grid, startpos, ?.)

    obstacle_positions =
      solve_part1(is_example) |> Enum.to_list() |> Enum.map(fn {{r, c}} -> {r, c} end)

    loop_positions =
      p2_solver(grid, width, height, startpos, obstacle_positions, MapSet.new())

    MapSet.size(loop_positions)
  end
end
