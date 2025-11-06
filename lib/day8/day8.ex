defmodule Day8 do
  def get_input(is_example) do
    ReadInput.read_lines(is_example, 8)
    |> Enum.with_index()
    |> Enum.map(fn {line, row_idx} ->
      {Enum.with_index(String.to_charlist(line)), row_idx}
    end)
    |> Enum.reduce([], fn {day_list, row_idx}, acc ->
      found =
        Enum.reduce(day_list, [], fn {ch, col_idx}, acc ->
          if ch != 46 do
            [{{row_idx, col_idx}, ch} | acc]
          else
            acc
          end
        end)

      if length(found) > 0 do
        [found | acc]
      else
        acc
      end
    end)
  end
end
