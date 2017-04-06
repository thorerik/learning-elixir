defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash_input
  end

  @doc """
  Hashes the input using the MD5 algorithm

  ## Examples

      iex> Identicon.main("meow")
      [74, 75, 228, 12, 150, 172, 99, 20, 233, 29, 147, 243, 128, 67, 166, 52]
  """
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
end
