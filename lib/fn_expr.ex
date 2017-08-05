defmodule FnExpr do

  @moduledoc"""
  Creates immediately invoked function expressions specifically
  [IIFE](http://benalman.com/news/2010/11/immediately-invoked-function-expression/)
  to be used with the pipe operator.

  The motiviation for this library was from Dave Thomas' short talk
  [Put This in Your Pipe](https://vimeo.com/216107561), which
  was awesome.  However, I found that the additional boilerplate
  syntax to *immediately-invoke* the function also a little *funky*.

  Here is a (contrived) example, using the pipe operator and anonymous
  functions directly

      iex> :apples
      ...> |> (fn atom -> Atom.to_string(atom) <> "__post" end).()
      ...> |> (fn (str) -> String.to_atom("pre__" <> str) end).()
      :pre__apples__post

  The same example can be represented with the `&` capture operator.

      iex> :apples
      ...> |> (&(Atom.to_string(&1) <> "__post")).()
      ...> |> (&(String.to_atom("pre__" <> &1))).()
      :pre__apples__post

  Neither look that great, so we are introducing a && capture-and-run
  operator, as well as `capture` macro which includes support for
  both capture expressions (`&1 + 1`), as well as anonymous
  functions (`fn x -> x + 1 end`).

  That same example above, would look like

      iex> :apples
      ...> |> FnExpr.&&(Atom.to_string(&1) <> "__post")
      ...> |> FnExpr.&&(String.to_atom("pre__" <> &1))
      :pre__apples__post

  If you prefer, you can `use FnExpr` like the following:

      defmodule FnExpr.ExampleInvoke do
        use FnExpr

        def piece_count(board) do
          board
          |> Enum.reduce({0, 0}, fn(piece, {black, white}) ->
                case piece do
                  :black -> {black+1, white}
                  :white -> {black, white+1}
                  _ -> {black, white}
                end
             end)
        end

        def total_pieces_on(board) do
          board
          |> piece_count
          |> invoke(fn {black, white} -> black + white end)
          |> invoke("Total pieces: \#{&1}")
        end

      end

  And a sample output would look like:

      iex> [nil, :black, nil, :black, :white, nil, :black]
      ...> |> FnExpr.ExampleInvoke.total_pieces_on
      "Total pieces: 4"

  In the example above, we are using the `invoke` macro, it
  takes the preceeding output from the pipe, as well as a
  function expression (or a capture expression).

  If you passs in a capture expression, then you only have
  `&1` available (the output from the previous pipe).
  Or, if you wanted greated pattern mataching, you can
  us the `fn` function expression notation.

  Here's a full example showing how to use the `&&` macro.
  Note that && is not directly supported in Elixir as a
  capture and immediately execute operator, so you will need
  to include the module name `FnExpr.&&`.

      defmodule FnExpr.ExampleAndAnd do
        require FnExpr

        def combine(atom) do
          atom
          |> FnExpr.&&(Atom.to_string(&1) <> "__post")
          |> FnExpr.&&(String.to_atom("pre__" <> &1))
        end

      end
  """
  defmacro __using__(_) do
    quote do
      defmacro invoke(piped_in_argument, expr) do
        fun = is_tuple(expr) && elem(expr, 0)
        case fun do
          :fn -> quote do (unquote(expr)).(unquote(piped_in_argument)) end
          _ -> quote do (&(unquote(expr))).(unquote(piped_in_argument)) end
        end
      end
    end
  end

  @doc"""
  Sometimes when working with piped operations, you might end up with a
  null value, and that's OK, but you would love to provde a defaulted value
  before continuing.

  For example,

        raw_input
        |> SomeOtherModule.process_all
        |> List.first
        |> default(%{id: "test_id"})
        |> Map.get(id)

  In the above, there is a chance that there were no widgets to process,
  but that's OK, you will just default it to a *near* empty map to allow
  it to flow through to `&Map.get/2` without throwing an exception
  """
  def default(piped_in_argument, default_value) do
    case piped_in_argument do
      nil -> default_value
      _ -> piped_in_argument
    end
  end

  @doc"""
  Creates function expression specifically to be used with the pipe operator.

  Here is a (contrived) example showing how it can be used

      iex> :apples
      ...> |> FnExpr.&&(Atom.to_string(&1) <> "__post")
      ...> |> FnExpr.&&(String.to_atom("pre__" <> &1))
      :pre__apples__post

  """
  defmacro unquote(:&&)(piped_in_argument, expr) do
    quote do
      (&(unquote(expr))).(unquote(piped_in_argument))
    end
  end

end
