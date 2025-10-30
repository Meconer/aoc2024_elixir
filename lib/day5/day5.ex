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
  def is_valid(page, rules) do
    pairs = Comparer.compare_all_unique_pairs(page)

    invalid =
      Enum.any?(pairs, fn {el1, el2} ->
        Enum.any?(rules, fn {r1, r2} ->
          r1 == el2 and r2 == el1
        end)
      end)

    not invalid
  end

  def get_middle_number(page) do
    len = length(page)
    Enum.at(page, div(len, 2))
  end

  def get_rules_and_pages(is_example) do
    [rules, pages] =
      ReadInput.read_input(is_example, 5)
      |> String.split("\n\n", trim: true)

    rules =
      String.split(rules, "\n", trim: true)
      |> Enum.map(&String.split(&1, "|", trim: true))
      |> Enum.map(fn [left, right] ->
        left_words = String.to_integer(left)
        right_words = String.to_integer(right)
        {left_words, right_words}
      end)

    pages =
      String.split(pages, "\n", trim: true)
      |> Enum.map(&String.split(&1, ",", trim: true))
      |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)

    [rules, pages]
  end

  def solve_part1(is_example) do
    [rules, pages] =
      get_rules_and_pages(is_example)

    result =
      Enum.map(pages, fn page ->
        cond do
          is_valid(page, rules) -> get_middle_number(page)
          true -> 0
        end
      end)
      |> Enum.sum()

    result
  end

  def is_in_order(num1, num2, rules) do
    cond do
      Enum.any?(rules, fn {n1, n2} -> num1 == n1 and num2 == n2 end) -> true
      true -> false
    end
  end

  def solve_part2(is_example) do
    [rules, pages] =
      get_rules_and_pages(is_example)

    result =
      Enum.map(pages, fn page ->
        cond do
          not is_valid(page, rules) ->
            Enum.sort(page, fn n1, n2 -> is_in_order(n1, n2, rules) end)
            |> get_middle_number()

          true ->
            0
        end
      end)

    Enum.sum(result)
  end
end
