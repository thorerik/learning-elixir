defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_colour
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image (input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image) 
  end

  def draw_image(%Identicon.Image{colour: colour, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(colour)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Removes odd squares from our grid

  ## Examples
      iex> imgStruct = Identicon.hash_input("meow")
      iex> imgStruct = Identicon.build_grid(imgStruct)
      iex> Identicon.filter_odd_squares(imgStruct)
      %Identicon.Image{
      grid: [{74, 0}, {228, 2}, {74, 4}, {12, 5}, {150, 6}, {172, 7}, {150, 8},
      {12, 9}, {20, 11}, {20, 13}, {128, 20}, {166, 22}, {128, 24}],
      hex: [74, 75, 228, 12, 150, 172, 99, 20, 233, 29, 147, 243, 128, 67, 166, 52]}
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _ }) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Builds the grid to use for indenticons

  ## Examples

      iex> imgStruct = Identicon.hash_input("meow")
      iex> Identicon.build_grid(imgStruct)
      %Identicon.Image{
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
