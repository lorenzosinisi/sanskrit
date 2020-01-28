defmodule Sanskrit.Ast.Wme do
  @moduledoc """
  A fact.

  A rapresentation of a working memory element in Rete. For example "Plant's name is monstera"

  ## Examples

      iex> Combine.parse("Plant's name is monstera", Sanskrit.Ast.Wme.parser())
      [%Sanskrit.Ast.Wme{attribute: "name", type: "Plant", value: "monstera"}]


      iex> Combine.parse("Plant's name is Pine", Sanskrit.Ast.Wme.parser())
      [%Sanskrit.Ast.Wme{attribute: "name", type: "Plant", value: "Pine"}]

      iex> Combine.parse("Plant's age is 1", Sanskrit.Ast.Wme.parser())
      [%Sanskrit.Ast.Wme{attribute: "age", type: "Plant", value: "1"}]

      iex> Combine.parse("Plant's age is 1", Sanskrit.Ast.Wme.parser())
      [%Sanskrit.Ast.Wme{attribute: "age", type: "Plant", value: "1"}]
  """

  use Sanskrit.Parser
  alias Sanskrit.Ast.ContextValue

  defstruct type: nil, attribute: nil, value: nil

  def new(type, attr, value) do
    %__MODULE__{type: type, attribute: attr, value: value}
  end

  def parser(_previous \\ nil) do
    pipe(
      [
        skip(ignore(spaces()))
        |> word()
        |> label("entity")
        |> skip(string("'s"))
        |> skip(spaces())
        |> word()
        |> label("attribute")
        |> skip(spaces())
        |> skip(string("is"))
        |> skip(spaces())
        |> either(word(), ContextValue.parser())
        |> label("value")
        |> skip(spaces())
      ],
      fn args ->
        case args do
          [type, attr, _is, value] -> new(type, attr, value)
          [type, attr, value] -> new(type, attr, value)
        end
      end
    )
  end
end
