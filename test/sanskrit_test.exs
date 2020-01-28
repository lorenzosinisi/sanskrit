defmodule SanskritTest do
  use ExUnit.Case
  doctest Sanskrit

  test "can parse HasAttribute" do
    assert {:ok,
            [
              %Sanskrit.Ast.HasAttribute{
                attribute: "surname",
                operator: :==,
                type: "Lorenzo",
                value: "sinisi"
              }
            ]} = Sanskrit.parse("Lorenzo's surname is equal sinisi")
  end

  test "the type in the attribute has to be followed by s" do
    assert {:error, "Expected end of input at line 1, column 0"} =
             Sanskrit.parse("Lorenzo' surname is equal sinisi")
  end

  test "can parse NewLine (ignoring it)" do
    assert {:ok, []} = Sanskrit.parse("\n")
  end

  test "can parse Wme" do
    assert {:ok,
            [
              %Sanskrit.Ast.Wme{
                attribute: "surname",
                type: "Lorenzo",
                value: "sinisi"
              }
            ]} = Sanskrit.parse("Lorenzo's surname is sinisi")
  end

  test "can parse a combination of HasAttribute, Wme and NewLines" do
    assert {:ok,
            [
              %Sanskrit.Ast.Wme{
                attribute: "surname",
                type: "Lorenzo",
                value: "sinisi"
              },
              %Sanskrit.Ast.Wme{attribute: "age", type: "Lorenzo", value: "28"},
              %Sanskrit.Ast.Wme{
                attribute: "country",
                type: "Lorenzo",
                value: "Germany"
              },
              %Sanskrit.Ast.HasAttribute{
                attribute: "language",
                operator: :==,
                type: "Lorenzo",
                value: "italian"
              },
              %Sanskrit.Ast.HasAttribute{
                attribute: "language",
                operator: :==,
                type: "Germany",
                value: "german"
              }
            ]} =
             Sanskrit.parse("""
             Lorenzo's surname is sinisi
             Lorenzo's age is 28
             Lorenzo's country is Germany
             Lorenzo's language is equal italian
             Germany's language is equal german
             """)
  end
end
