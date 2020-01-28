defmodule Sanskrit.Ast.ContextValue do
  use Sanskrit.Parser

  @moduledoc """
  A word prepended with an hashtag

  ## Example

      iex> Combine.parse("#lorenzo", Sanskrit.Ast.ContextValue.parser())
      [%Sanskrit.Ast.ContextValue{value: "#lorenzo"}]
  """

  defstruct value: nil

  def new(value) do
    %__MODULE__{value: "#" <> value}
  end

  def parser(_prev \\ nil) do
    ignore(char("#"))
    |> word()
    |> map(fn word -> new(word) end)
  end
end
