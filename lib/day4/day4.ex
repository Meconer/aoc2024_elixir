defmodule Day4 do
  def get_input(is_example) do
    lines = ReadInput.read_lines(is_example, 4)
    width = String.length(List.first(lines))
    height = length(lines)

    tuples =
      lines
      |> Enum.map(fn el ->
        String.to_charlist(el)
        |> List.to_tuple()
      end)
      |> :erlang.list_to_tuple()

    {tuples, width, height}
  end

  def get_letter(r, c, grid) do
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

  def get_cross_letters(r, c, grid) do
    get_letter(r - 1, c - 1, grid) <>
      get_letter(r - 1, c + 1, grid) <>
      get_letter(r + 1, c - 1, grid) <>
      get_letter(r + 1, c + 1, grid)
  end

  defmodule CrossCounter do
    def start_count(r, c, grid) do
      directions = [
        n: {-1, 0},
        ne: {-1, 1},
        e: {0, 1},
        se: {1, 1},
        s: {1, 0},
        sw: {1, -1},
        w: {0, -1},
        nw: {-1, -1}
      ]

      # TODO: replace with your counting logic. Example placeholder:
      Enum.reduce(directions, %{:l => "", :cnt => 0}, fn {_name, {dr, dc}}, acc ->
        l = acc.l <> get_letters_in_dir(r, c, dr, dc, 3, grid, "")
        IO.puts("#{r}, #{c} : #{l}")

        case l do
          "XMAS" ->
            IO.puts("Found xmas")
            %{:l => "", :cnt => acc.cnt + 1}

          _ ->
            %{:l => "", :cnt => acc.cnt}
        end
      end).cnt
    end

    defp get_letters_in_dir(r, c, dr, dc, count, grid, acc_letters) do
      height = tuple_size(grid)
      first_row = :erlang.element(1, grid)
      width = tuple_size(first_row)

      case {r, c} do
        {_r, _c} when r < 1 ->
          acc_letters

        {_r, _c} when r > height ->
          acc_letters

        {_r, _c} when c < 1 ->
          acc_letters

        {_r, _c} when c > width ->
          acc_letters

        {r, c} ->
          letter = Day4.get_letter(r, c, grid)

          case count do
            0 ->
              acc_letters <> letter

            _ ->
              get_letters_in_dir(r + dr, c + dc, dr, dc, count - 1, grid, acc_letters <> letter)
          end
      end
    end
  end

  def count_xmas(grid, width, height) do
    for row <- 1..height,
        do:
          for(col <- 1..width, do: {row, col})
          |> Enum.map(fn {r, c} ->
            letter = get_letter(r, c, grid)

            case letter do
              "X" ->
                CrossCounter.start_count(r, c, grid)

              _ ->
                0
            end
          end)
  end

  defp correct_combos do
    [""]
  end

  def count_xmas_p2(grid, width, height) do
    for row <- 1..height,
        do:
          for(col <- 1..width, do: {row, col})
          |> Enum.map(fn {r, c} ->
            letter = get_letter(r, c, grid)

            case letter do
              "A" ->
                cross_letters = get_cross_letters(r, c, grid)
                Enum.any?()

              _ ->
                0
            end
          end)
  end

  def solve_part1(is_example) do
    {grid, width, height} = get_input(is_example)

    xmases = count_xmas(grid, width, height)
    xmases |> Enum.map(fn row -> Enum.sum(row) end) |> Enum.sum()
  end

  def solve_part2(is_example) do
    {grid, width, height} = get_input(is_example)
    xmases = count_xmas_p2(grid, width, height)
    xmases |> Enum.map(fn row -> Enum.sum(row) end) |> Enum.sum()
  end
end
