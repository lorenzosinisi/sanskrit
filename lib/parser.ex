defmodule Sanskrit.Parser do
  @moduledoc false
  defmodule Behaviour do
    @callback parser(term) :: list(term) | {:error, String.t()}
    @callback parser() :: list(term) | {:error, String.t()}
  end

  use Combine
  import Elixir.Combine.Parsers.Base

  @doc "Given a string, apply many time each defined parser and succeed if the end of the binary is reached"
  def parse(str) when is_binary(str) do
    Combine.parse(str, many(generic_parser()) |> eof())
  end

  defp generic_parser(previous \\ nil) do
    previous
    |> choice([
      ignore(spaces()),
      func(),
      filter_parser(),
      has_attribute(),
      has_no_attribute(),
      wme(),
      isa(),
      ignore(newline()),
      ignore(spaces())
    ])
  end

  def literal_string(previous \\ nil) do
    string_regex = ~r/(?:\\"|[^\\"])*/

    previous
    |> between(
      char("\""),
      label(word_of(string_regex), "string"),
      char("\"")
    )
    |> map(fn str -> String.replace(str, "\\\"", "\"") end)
  end

  def array(previous \\ nil) do
    previous
    |> between(
      char("["),
      many(
        choice([
          range(),
          negative_number(),
          float(),
          integer(),
          literal_string(),
          ignore(spaces()),
          ignore(char(","))
        ])
      ),
      char("]")
    )
  end

  def func(previous \\ nil) do
    previous
    |> pipe(
      [
        skip(ignore(spaces()))
        |> string("let")
        |> label("let_keyword")
        |> skip(spaces())
        |> variable()
        |> label("variable_name")
        |> skip(spaces())
        |> string("=")
        |> skip(spaces())
        |> word()
        |> skip(spaces())
        |> between(
          char("("),
          many(
            choice([
              choice([
                negative_number(),
                variable(),
                float(),
                integer(),
                literal_string()
              ]),
              ignore(spaces()),
              ignore(char(","))
            ])
          ),
          char(")")
        )
        |> skip(spaces())
      ],
      fn args ->
        case args do
          ["let", _, variable_name, _, function_name, arguments] ->
            {:fun, variable_name, function_name, arguments}
        end
      end
    )
  end

  def filter_parser(previous \\ nil) do
    previous
    |> pipe(
      [
        skip(ignore(spaces()))
        |> string("when")
        |> ignore(spaces())
        |> variable()
        |> label("variable")
        |> skip(spaces())
        |> choice([
          string("in"),
          string("equal"),
          string("not"),
          string("greater"),
          string("greater_or_equal"),
          string("lesser"),
          string("lesser_or_equal"),
          string("="),
          string("<="),
          string(">="),
          string("!="),
          string(">"),
          string("<")
        ])
        |> skip(spaces())
        |> choice([negative_number(), float(), integer(), literal_string(), array()])
        |> skip(spaces())
      ],
      fn args ->
        case args do
          [_, _, _, type, "equal", value] ->
            {:filter, type, :==, value}

          [_, _, _, type, "in", value] ->
            {:filter, type, :in, value}

          [_, _, _, type, "is", value] ->
            {:filter, type, :==, value}

          [_, _, _, type, "=", value] ->
            {:filter, type, :==, value}

          [_, _, _, type, "not", value] ->
            {:filter, type, :!=, value}

          [_, _, _, type, "!=", value] ->
            {:filter, type, :!=, value}

          [_, _, _, type, "lesser", value] ->
            {:filter, type, :<, value}

          [_, _, _, type, "<", value] ->
            {:filter, type, :<, value}

          [_, _, _, type, "lesser_or_equal", value] ->
            {:filter, type, :<=, value}

          [_, _, _, type, "<=", value] ->
            {:filter, type, :<=, value}

          [_, _, _, type, "greater", value] ->
            {:filter, type, :>, value}

          [_, _, _, type, ">", value] ->
            {:filter, type, :>, value}

          [_, _, _, type, "greater_or_equal", value] ->
            {:filter, type, :>=, value}

          [_, _, _, type, ">=", value] ->
            {:filter, type, :>=, value}
        end
      end
    )
  end

  def has_no_attribute(previous \\ nil) do
    previous
    |> pipe(
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
        |> string("unknown")
        |> skip(spaces())
      ],
      fn [type, attr, "unknown"] ->
        {:not_existing_attribute, type, attr}
      end
    )
  end

  defp boolean(previous \\ nil) do
    previous
    |> either(string("true"), string("false"))
    |> map(fn str ->
      case str do
        "true" -> true
        "false" -> false
      end
    end)
  end

  def has_attribute(previous \\ nil) do
    previous
    |> pipe(
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
        |> choice([
          string("in"),
          string("equal"),
          string("not"),
          string("greater"),
          string("lesser"),
          string("unknonw"),
          string("equal"),
          string("="),
          string(">="),
          string("<="),
          string("!="),
          string(">"),
          string("<"),
          string("unknonw")
        ])
        |> skip(spaces())
        |> choice([
          negative_number(),
          float(),
          integer(),
          boolean(),
          literal_string(),
          variable(),
          context_value(),
          array()
        ])
        |> skip(spaces())
      ],
      fn args ->
        case args do
          [type, attr, "equal", value] ->
            {:has_attribute, type, attr, :==, value}

          [type, attr, "equal", _, value] ->
            {:has_attribute, type, attr, :==, value}

          [type, attr, "=", value] ->
            {:has_attribute, type, attr, :==, value}

          [type, attr, "in", value] ->
            {:has_attribute, type, attr, :in, value}

          [type, attr, "!=", value] ->
            {:has_attribute, type, attr, :!=, value}

          [type, attr, "not", value] ->
            {:has_attribute, type, attr, :!=, value}

          [type, attr, "lesser", value] ->
            {:has_attribute, type, attr, :<, value}

          [type, attr, "<", value] ->
            {:has_attribute, type, attr, :<, value}

          [type, attr, "lesser_or_equal", value] ->
            {:has_attribute, type, attr, :<, value}

          [type, attr, "<=", value] ->
            {:has_attribute, type, attr, :<=, value}

          [type, attr, "greater", value] ->
            {:has_attribute, type, attr, :>, value}

          [type, attr, ">", value] ->
            {:has_attribute, type, attr, :>, value}

          [type, attr, "greater_or_equal", value] ->
            {:has_attribute, type, attr, :>=, value}

          [type, attr, ">=", value] ->
            {:has_attribute, type, attr, :>=, value}

          [type, attr, "unknonw", _value] ->
            {:not_existing_attribute, type, attr}

          [type, attr, value] ->
            {:has_attribute, type, attr, :==, value}
        end
      end
    )
  end

  def is_not(previous \\ nil) do
    previous
    |> pipe(
      [
        skip(spaces())
        |> variable()
        |> label("variable")
        |> skip(spaces())
        |> string("not")
        |> literal_string()
        |> skip(spaces())
        |> label("entity_name")
        |> skip(spaces())
      ],
      fn args ->
        case args do
          [_, variable, type] -> {:negation, variable, type}
        end
      end
    )
  end

  def isa(previous \\ nil) do
    previous
    |> pipe(
      [
        skip(spaces())
        |> variable()
        |> label("variable")
        |> skip(spaces())
        |> choice([string("isa"), string("is_not")])
        |> skip(spaces())
        |> choice([word(), literal_string()])
        |> label("entity_name")
        |> skip(spaces())
      ],
      fn args ->
        case args do
          [_, variable, "isa", type] -> {:isa, variable, type}
          [_, variable, "is_not", type] -> {:not, variable, type}
        end
      end
    )
  end

  def wme(previous \\ nil) do
    previous
    |> pipe(
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
        |> choice([
          range(),
          negative_number(),
          float(),
          integer(),
          boolean(),
          literal_string(),
          variable(),
          context_value(),
          array()
        ])
        |> label("value")
        |> skip(spaces())
      ],
      fn args ->
        case args do
          [type, attr, _is, value] -> {:wme, type, attr, value}
          [type, attr, value] -> {:wme, type, attr, value}
        end
      end
    )
  end

  def variable(previous \\ nil) do
    previous
    |> ignore(char("$"))
    |> word()
    |> map(fn word -> "$#{word}" end)
  end

  def range(previous \\ nil) do
    previous
    |> pipe(
      [
        choice([
          negative_number(),
          float(),
          integer()
        ]),
        string(".."),
        choice([
          negative_number(),
          float(),
          integer()
        ])
      ],
      fn [first, "..", last] -> Range.new(first, last) end
    )
  end

  def context_value(previous \\ nil) do
    previous
    |> ignore(char("#"))
    |> word()
    |> map(fn word -> "##{word}" end)
  end

  def negative_number(previous \\ nil) do
    previous
    |> pipe(
      [
        ignore(char("-")),
        choice([
          float(),
          integer()
        ])
      ],
      fn [int] -> -int end
    )
  end

  defmacro __using__(_opts) do
    quote do
      use Combine
      import Elixir.Combine.Parsers.Base
      @behaviour Sanskrit.Parser.Behaviour
    end
  end
end
