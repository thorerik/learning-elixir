defmodule Cards do
  @moduledoc """
  Documentation for Cards.
  """

  def create_deck do
    values = ["Ace",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine",
      "Ten",
      "Jack",
      "Queen",
      "King"]
    suits = ["Spades", "Clubs", "Hearts", "Diamond"]
    for suit <- suits do
      suit
    end
  end

  def shuffle(deck) do
      Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end
end
