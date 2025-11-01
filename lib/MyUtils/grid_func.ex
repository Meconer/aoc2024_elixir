defmodule GridFunc do
  def get_char(r, c, grid) do
    height = tuple_size(grid)

    first_row = :erlang.element(1, grid)
    width = tuple_size(first_row)

    case {r, c} do
      {r, _c} when r < 1 ->
        ""

      {_r, c} when c < 1 ->
        ""

      {r, _c} when r > height ->
        ""

      {_r, c} when c > width ->
        ""

      {r, c} ->
        row = :erlang.element(r, grid)
        c = :erlang.element(c, row)
        <<c>>
    end
  end

  def get_char({r, c}, grid) do
    get_char(r, c, grid)
  end

  def print_grid(grid) do
    grid_as_lists =
      Tuple.to_list(grid)
      |> Enum.map(&Tuple.to_list/1)

    Enum.each(grid_as_lists, fn row ->
      row_str =
        row
        |> Enum.map(fn ch -> <<ch>> end)
        |> Enum.join("")

      IO.puts(row_str)
    end)
  end
end
