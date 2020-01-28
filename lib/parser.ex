defmodule Sanskrit.Parser do
  defmodule Behaviour do
    @callback parser(term) :: list(term) | {:error, String.t()}
    @callback parser() :: list(term) | {:error, String.t()}
  end

  use Combine
  import Elixir.Combine.Parsers.Base
  alias Sanskrit.Ast.{HasAttribute, Wme, NewLine}

  @doc "Given a string, apply many time each defined parser and succeed if the end of the binary is reached"
  def parse(str) when is_binary(str) do
    Combine.parse(str, many(parser()) |> eof())
  end

  defp parser do
    choice([HasAttribute.parser(), Wme.parser(), ignore(NewLine.parser())])
  end

  defmacro __using__(_opts) do
    quote do
      use Combine
      import Elixir.Combine.Parsers.Base
      @behaviour Sanskrit.Parser.Behaviour
    end
  end
end
