defmodule Day9 do
  defmodule RecParser do
    defp parse([], _pos, _id, _file_acc, _empty_acc) do
      raise("Must be odd number of chars")
    end

    defp parse([fs], pos, id, file_acc, empty_acc) do
      len = fs - ?0
      file_acc = [%{:id => id, :start => pos, :len => len} | file_acc]
      {Enum.reverse(file_acc), Enum.reverse(empty_acc)}
    end

    defp parse([fs, es | rest], pos, id, file_acc, empty_acc) do
      len = fs - ?0
      file_acc = [%{:id => id, :start => pos, :len => len} | file_acc]
      empty_len = es - ?0
      empty_acc = [%{:start => pos + len, :len => empty_len} | empty_acc]
      parse(rest, pos + len + empty_len, id + 1, file_acc, empty_acc)
    end

    def parse_list(ch_list) do
      parse(ch_list, 0, 0, [], [])
    end
  end

  def parse_input(is_example) do
    input = ReadInput.read_input(is_example, 9)
    ch_list = String.to_charlist(input)
    ch_list |> length()
  end
end
