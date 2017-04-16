defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_colour
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
