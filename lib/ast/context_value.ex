defmodule Sanskrit.Ast.ContextValue do
  use Sanskrit.Parser

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
