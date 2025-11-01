defmodule GridFunc do
  def set_char(grid, {row, col}, new_char) do
    # 1. RETRIEVE the original row tuple using 0-based index
    original_row = :erlang.element(row + 1, grid)

    # 2. CREATE the NEW row tuple with the updated element
    #    :erlang.setelement(ColIndex, OriginalRowTuple, NewChar)
    new_row = :erlang.setelement(col + 1, original_row, new_char)

    # 3. CREATE the NEW grid tuple with the updated row
    #    :erlang.setelement(RowIndex, OriginalGridTuple, NewRowTuple)
    new_grid = :erlang.setelement(row + 1, grid, new_row)

    new_grid
  end

  def get_char(r, c, grid) do
    height = tuple_size(grid)

    first_row = :erlang.element(1, grid)
    width = tuple_size(first_row)

    case {r, c} do
      {r, _c} when r < 0 ->
        ""

      {_r, c} when c < 0 ->
        ""

      {r, _c} when r >= height ->
        ""

      {_r, c} when c >= width ->
        ""

      {r, c} ->
        row = :erlang.element(r + 1, grid)
        c = :erlang.element(c + 1, row)
        <<c>>
    end
  end

  def get_char({r, c}, grid) do
    get_char(r, c, grid)
  end

  def find_in_grid(grid, ch_to_find) do
    grid_as_lists =
      Tuple.to_list(grid)
      |> Enum.map(&Tuple.to_list/1)

    row_idx =
      Enum.find_index(grid_as_lists, fn row ->
        Enum.member?(row, ch_to_find)
      end)

    row = :erlang.element(row_idx + 1, grid)

    col_idx =
      Enum.find_index(Tuple.to_list(row), fn ch -> ch == ch_to_find end)

    {row_idx, col_idx}
  end

  def conv_grid_to_lists(grid) do
    Tuple.to_list(grid)
    |> Enum.map(&Tuple.to_list/1)
  end

  def print_tuple_grid(grid) do
    print_grid(conv_grid_to_lists(grid))
  end

  def print_grid(grid) do
    Enum.each(grid, fn row ->
      row_str =
        row
        |> Enum.map(fn ch -> <<ch>> end)
        |> Enum.join("")

      IO.puts(row_str)
    end)
  end

  def print_tuple_grid(grid, pos, dir) do
    print_grid(conv_grid_to_lists(grid), pos, dir)
  end

  def print_grid(grid_as_lists, pos, dir) do
    dir_ch =
      case dir do
        :north -> ?^
        :east -> ?>
        :south -> ?v
        :west -> ?<
      end

    mod_lists =
      Enum.with_index(grid_as_lists)
      |> Enum.map(fn {row, row_idx} ->
        Enum.with_index(row)
        |> Enum.map(fn {ch, col_idx} ->
          cond do
            {row_idx, col_idx} == pos -> dir_ch
            true -> ch
          end
        end)
      end)

    print_grid(mod_lists)
  end
end
