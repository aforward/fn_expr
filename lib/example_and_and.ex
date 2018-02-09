defmodule FnExpr.ExampleAndAnd do
  require FnExpr

  @moduledoc false

  def combine(atom) do
    atom
    |> FnExpr.&&(Atom.to_string(&1) <> "__post")
    |> FnExpr.&&(String.to_atom("pre__" <> &1))
  end
end
