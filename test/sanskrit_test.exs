defmodule SanskritTest do
  use ExUnit.Case
  import Sanskrit, only: [parse: 1]

  test "can parse HasAttribute" do
    assert {:ok, [{:has_attribute, "Lorenzo", "surname", :==, "sinisi"}]} =
             Sanskrit.parse("""
             Lorenzo's surname is equal "sinisi"
             """)
  end

  test "the type in the attribute has to be followed by s" do
    assert {:error, "Expected end of input at line 1, column 0"} =
             Sanskrit.parse("Lorenzo' surname is equal sinisi")
  end

  test "can parse isa" do
    text = """
    $name isa Person
    """

    assert {:ok, [{:isa, "$name", "Person"}]} ==
             Sanskrit.parse(text)
  end

  test "can parse is_not" do
    text = """
    $name is_not Lorenzo
    """

    assert {:ok, [{:not, "$name", "Lorenzo"}]} ==
             Sanskrit.parse(text)

    text = """
    $name is_not "Lorenzo"
    """

    assert {:ok, [{:not, "$name", "Lorenzo"}]} ==
             Sanskrit.parse(text)
  end

  test "can no existing attribues" do
    text = """
    Person's name is unknown
    """

    assert {:ok, [{:unexistant_attribute, "Person", "name"}]} ==
             Sanskrit.parse(text)
  end

  test "can parse filters" do
    for {operator, symbol} <- [
          {"equal", :==},
          {"in", :in},
          {"not", :!=},
          {"lesser", :<},
          {"greater", :>}
        ] do
      text = """
      when $name #{operator} "ciao"
      """

      assert {:ok, [{:filter, "$name", symbol, "ciao"}]} ==
               Sanskrit.parse(text)
    end
  end

  test "can parse NewLine (ignoring it)" do
    assert {:ok, []} = Sanskrit.parse("\n")
  end

  test "can parse functions" do
    assert {:ok, [{:fun, "$name", "surname_of", ["$sinisi"]}]} =
             parse("""
             let $name = surname_of($sinisi)
             """)
  end

  test "can parse Wme" do
    assert {:ok, [{:wme, "Lorenzo", "surname", "sinisi"}]} =
             parse("""
             Lorenzo's surname is "sinisi"
             """)
  end

  test "fails when a has attribute is not complete" do
    assert {:error, "Expected end of input at line 4, column 0"} =
             parse("""
             Lorenzo's surname is "sinisi"
             Lorenzo's age is 28
             Lorenzo's country is "Germany"
             Lorenzo's language is equal
             Germany's language is equal "german"
             """)
  end

  test "can parse a combination of HasAttribute, Wme and NewLines" do
    assert {:ok,
            [
              {:wme, "Lorenzo", "surname", "sinisi"},
              {:wme, "Lorenzo", "age", 28},
              {:wme, "Lorenzo", "country", "Germany"},
              {:has_attribute, "Lorenzo", "language", :==, "italian"},
              {:has_attribute, "Germany", "language", :==, "german"}
            ]} =
             parse("""
             Lorenzo's surname is "sinisi"
             Lorenzo's age is 28
             Lorenzo's country is "Germany"
             Lorenzo's language is equal "italian"
             Germany's language is equal "german"
             """)
  end

  test "can parse all statements" do
    assert {:ok,
            [
              {:wme, "Dog", "isa", "$x"},
              {:wme, "Lorenzo", "surname", "sinisi"},
              {:wme, "Lorenzo", "age", 28},
              {:wme, "Lorenzo", "country", "Germany"},
              {:has_attribute, "Lorenzo", "language", :==, "italian"},
              {:has_attribute, "Germany", "language", :==, "german"},
              {:fun, "$surname", "surname_of", ["$sinisi"]},
              {:filter, "$surname", :==, "ciao"},
              {:not, "$x", "Duck"},
              {:unexistant_attribute, "Dog", "age"}
            ]} =
             parse("""
             Dog isa $x
             Lorenzo's surname is "sinisi"
             Lorenzo's age is 28
             Lorenzo's country is "Germany"
             Lorenzo's language is equal "italian"
             Germany's language is equal "german"
             let $surname = surname_of($sinisi)
             when $surname equal "ciao"
             $x is_not Duck
             Dog's age is unknown
             """)
  end
end
