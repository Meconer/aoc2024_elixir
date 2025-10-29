defmodule Comparer do
  @doc """
  Compares every element in a list to every other element once.
  Returns a list of tuples {element_A, element_B} for every unique pair.
  """
  def compare_all_unique_pairs(list) do
    # 1. Use Enum.with_index/1 to get both the element and its position
    indexed_list = Enum.with_index(list)

    # 2. Use a 'for' comprehension with two generators
    for {element_A, index_A} <- indexed_list,
        {element_B, index_B} <- indexed_list,
        # 3. Filter the pairs: only keep pairs where index_A is less than index_B.
        # This ensures two things:
        #    a) We exclude comparing an element to itself (index_A != index_B).
        #    b) We only generate the pair once (e.g., we get {1, 2} but not {2, 1}).
        index_A < index_B do
      # 4. Return the pair
      {element_A, element_B}
    end
  end
end

defmodule Day5 do
  def solve_part1(is_example) do
    [a, b] =
      ReadInput.read_input(is_example, 5)
      |> String.split("\n\n", trim: true)

    a =
      String.split(a, "\n", trim: true)
      |> Enum.map(&String.split(&1, "|", trim: true))
      |> Enum.map(fn [left, right] ->
        left_words = String.to_integer(left)
        right_words = String.to_integer(right)
        {left_words, right_words}
      end)

    b =
      String.split(b, "\n", trim: true)
      |> Enum.map(&String.split(&1, ",", trim: true))
      |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)

    {a, b}
  end
end
