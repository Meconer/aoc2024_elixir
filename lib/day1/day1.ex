defmodule Day1 do
  def read_input(filename) do
    file_path = Path.join("lib/day1/", filename)

    case File.read(file_path) do
      {:ok, content} ->
        # Split the content into a list of lines
        lines = String.split(content, ~r/\r\n|\n/, trim: true)

        # Process the list of lines
        IO.puts("Total lines read: #{length(lines)}")

      # ... further list processing

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end
