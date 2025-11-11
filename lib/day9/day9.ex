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

      empty_acc =
        if empty_len == 0 do
          empty_acc
        else
          [%{:start => pos + len, :len => empty_len} | empty_acc]
        end

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
    defp rec_compact(files, [], acc_fs) do
      # No more empty space
      acc_fs ++ files
    end

    defp rec_compact([], _empties, acc_fs) do
      # No more files
      acc_fs
    end

    defp rec_compact(files, empties, acc_fs) do
      # Get the first file
      [%{id: _f_id, start: f_start, len: _f_len} = first_file | fs_rest] = files
      # Get the first empty space
      [%{start: e_start, len: e_len} | e_rest] = empties

      cond do
        f_start < e_start ->
          # Next entity is a file. Copy it to the acc
          new_acc_fs = acc_fs ++ [first_file]
          rec_compact(fs_rest, empties, new_acc_fs)

        f_start > e_start ->
          # Next entity is empty space
          # Get the last file. We will use it to fill the empty space
          %{id: l_id, start: l_start, len: l_len} = List.last(files)

          cond do
            # Entire file fits in this empty space with room left
            l_len < e_len ->
              new_empties = [%{start: e_start + l_len, len: e_len - l_len} | e_rest]
              new_acc_fs = acc_fs ++ [%{id: l_id, start: e_start, len: l_len}]
              [_ | files_with_last_removed] = Enum.reverse(files)
              rec_compact(Enum.reverse(files_with_last_removed), new_empties, new_acc_fs)

            # Entire file fits perfectly
            l_len == e_len ->
              new_acc_fs = acc_fs ++ [%{id: l_id, start: e_start, len: l_len}]
              [_ | files_with_last_removed] = Enum.reverse(files)
              rec_compact(Enum.reverse(files_with_last_removed), e_rest, new_acc_fs)

            # We have to split the file
            l_len > e_len ->
              new_acc_fs = acc_fs ++ [%{id: l_id, start: e_start, len: e_len}]
              [_ | files_with_last_removed] = Enum.reverse(files)

              new_files =
                [
                  %{id: l_id, start: l_start, len: l_len - e_len}
                  | files_with_last_removed
                ]
                |> Enum.reverse()

              rec_compact(new_files, e_rest, new_acc_fs)
          end
      end
    end

    def calc_checksum(fs) do
    end

    def compact_fs({files, empties}) do
      # Compact the filesystem by moving files into empty spaces
      # Get the first file and put in the new resulting file sys
      new_fs = rec_compact(files, empties, [])
      calc_checksum(new_fs)
    end
  end

  def solve_part1(is_example) do
    {files, empties} = parse_input(is_example)

    new_fs = FsCompacter.compact_fs({files, empties})
    new_fs
  end
end
