defmodule Sanskrit.Ast.Wme do
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
