defmodule FnExpr.ExampleInvoke do
  use FnExpr

  @moduledoc false

  def piece_count(board) do
    board
    |> Enum.reduce({0, 0}, fn piece, {black, white} ->
      case piece do
        :black -> {black + 1, white}
        :white -> {black, white + 1}
        _ -> {black, white}
      end
    end)
  end

  def total_pieces_on(board) do
    board
    |> piece_count
    |> invoke(fn {black, white} -> black + white end)
    |> invoke("Total pieces: #{&1}")
  end

  def combine(atom) do
    atom
    |> invoke({Atom.to_string(&1), "__post"})
    |> invoke(fn {middle, last} -> String.to_atom("pre__" <> middle <> last) end)
  end
end
