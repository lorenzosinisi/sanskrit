defmodule Sanskrit.Ast.HasAttribute do
  use Sanskrit.Parser
  alias Sanskrit.Ast.ContextValue

  defstruct type: nil, attribute: nil, operator: :==, value: nil

  def new(type, attr, operator, value) do
    %__MODULE__{type: type, attribute: attr, operator: operator, value: value}
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
        |> choice([string("equal"), string("not"), string("greater"), string("lesser")])
        |> skip(spaces())
        |> either(word(), ContextValue.parser())
        |> skip(spaces())
      ],
      fn args ->
        case args do
          [type, attr, "equal", value] ->
            new(type, attr, :==, value)

          [type, attr, "not", value] ->
            new(type, attr, :!=, value)

          [type, attr, "lesser", value] ->
            new(type, attr, :<=, value)

          [type, attr, "greater", value] ->
            new(type, attr, :>=, value)

          [type, attr, value] ->
            new(type, attr, :==, value)
        end
      end
    )
  end
end
