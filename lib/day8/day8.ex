defmodule Day8 do
  def get_input(is_example) do
    ReadInput.read_lines(is_example, 8)
    |> Enum.with_index()
    |> Enum.map(fn {line, row_idx} ->
      {Enum.with_index(String.to_charlist(line)), row_idx}
    end)
    |> Enum.reduce(MapSet.new(), fn {day_list, row_idx}, acc ->
      IO.inspect(row_idx)
      IO.inspect(day_list)
    end)
  end
end
