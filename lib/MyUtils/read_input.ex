defmodule ReadInput do
  def get_file_path(is_example, day_no) do
    fname = if is_example, do: "example.txt", else: "input.txt"
    dir_part = "lib/day" <> Integer.to_string(day_no) <> "/"
    dir_part <> fname
  end

  def read_lines(is_example, day_no) do
    file_path = get_file_path(is_example, day_no)

    case File.read(file_path) do
      {:ok, content} ->
        # Split the content into a list of lines
        lines = String.split(content, ~r/\r\n|\n/, trim: true)

        # Process the list of lines
        IO.puts("Total lines read: #{length(lines)}")
        lines

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
