defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_colour
    |> build_grid
  end

  @doc """
  Builds the grid to use for indenticons

  ## Examples

      iex> imgStruct = Identicon.hash_input("meow")
      iex> Identicon.build_grid(imgStruct)
      %Identicon.Image{colour: nil,
      grid: [{74, 0}, {75, 1}, {228, 2}, {75, 3}, {74, 4}, {12, 5}, {150, 6},
      {172, 7}, {150, 8}, {12, 9}, {99, 10}, {20, 11}, {233, 12}, {20, 13},
      {99, 14}, {29, 15}, {147, 16}, {243, 17}, {147, 18}, {29, 19}, {128, 20},
      {67, 21}, {166, 22}, {67, 23}, {128, 24}],
      hex: [74, 75, 228, 12, 150, 172, 99, 20, 233, 29, 147, 243, 128, 67, 166, 52]}
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Mirrors a row for identicons

  ## Examples

      iex> Identicon.mirror_row([1,2,3])
      [1, 2, 3, 2, 1]

  """
  def mirror_row([first, second | _] = row) do
    row ++ [second, first]
  end

  @doc """
  Picks the colour off the hash and adds it to our struct

  ## Examples

      iex> imgStruct = Identicon.hash_input ("meow")
      iex> Identicon.pick_colour(imgStruct)
      %Identicon.Image{colour: {74, 75, 228},
      hex: [74, 75, 228, 12, 150, 172, 99, 20, 233, 29, 147, 243, 128, 67, 166, 52]}
  """
  def pick_colour(%Identicon.Image{hex: [r,g,b|_]} = image) do
    %Identicon.Image{image | colour: {r, g, b}}
  end

  @doc """
  Hashes the input using the MD5 algorithm

  ## Examples

      iex> Identicon.hash_input("meow")
      %Identicon.Image{hex: [74, 75, 228, 12, 150, 172, 99, 20, 233, 29, 147, 243,
      128, 67, 166, 52]}
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
