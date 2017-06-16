defmodule FnExprTest do
  use ExUnit.Case
  doctest FnExpr

  alias FnExpr.ExampleAndAnd, as: E1
  alias FnExpr.ExampleInvoke, as: E2

  test "require FnExpr, and call FnExpr.&&(...)" do
    assert E1.combine(:middle) == :pre__middle__post
  end

  test "use FnExpr, and call capture(..)" do
    assert E2.combine(:middle) == :pre__middle__post
  end

  test "total_pieces_on" do
    board = [nil, :black, nil, :black, :white, nil, :black]
    assert E2.total_pieces_on(board) == "Total pieces: 4"
  end

end
