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
    ch_list |> RecParser.parse_list()
  end

  defmodule FsCompacter do
    defp rec_compact(_files_rev, [], acc_fs) do
      acc_fs
    end

    defp rec_compact(files_rev, empties, acc_fs) do
      [%{id: id, start: f_start, len: f_len} | fs_rest] = files_rev
      [%{start: e_start, len: e_len} | e_rest] = empties

      cond do
        # Entire file fits in this empty space with room left
        f_len < e_len ->
          new_empties = [%{start: e_start + f_len, len: e_len - f_len} | e_rest]
          new_acc_fs = [%{id: id, start: e_start, len: f_len} | fs_rest]
          rec_compact(fs_rest, new_empties, new_acc_fs)

        # Entire file fits perfectly
        f_len == e_len ->
          new_acc_fs = [%{id: id, start: e_start, len: f_len} | fs_rest]
          rec_compact(fs_rest, e_rest, new_acc_fs)

        # We have to split the file
        f_len > e_len ->
          new_fs = [%{id: id, start: f_start, len: f_len - e_len} | fs_rest]
          new_acc_fs = [%{id: id, start: e_start, len: e_len} | fs_rest]
          rec_compact(new_fs, e_rest, new_acc_fs)
      end
    end

    def compact_fs({files, empties}) do
      # Compact the filesystem by moving files into empty spaces
      new_fs = rec_compact(Enum.reverse(files), empties, [])
      Enum.reverse(new_fs)
    end
  end

  def solve_part1(is_example) do
    {files, empties} = parse_input(is_example)
    new_fs = FsCompacter.compact_fs({files, empties})
    new_fs
  end
end
