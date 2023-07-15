defmodule SanskritTest do
  use ExUnit.Case
  import Sanskrit, only: [parse: 1]

  test "can parse HasAttribute" do
    assert {:ok, [{:has_attribute, "Person", "surname", :==, "sinisi"}]} =
             Sanskrit.parse("""
             Person's surname is equal "sinisi"
             """)
  end

  test "the type in the attribute has to be followed by s" do
    assert {:error, "Expected end of input at line 1, column 0"} =
             Sanskrit.parse("Person' surname is equal sinisi")
  end

  test "can parse isa" do
    text = """
    $name isa Person
    """

    assert {:ok, [{:isa, "$name", "Person"}]} ==
             Sanskrit.parse(text)
  end

  test "can parse attribute literals" do
    text = """
    Vomit's composition is in [\"Water\", \"Food+Water\", \"Just-Bile\"]\r\nDog's problem is equal \"Gastrointestinal\"\r\nAnagrafic's age is equal $age\r\nAnagrafic's age is equal 1\r\nAnagrafic's name is equal $name\r\n
    """

    assert {:ok,
            [
              {:has_attribute, "Vomit", "composition", :in, ["Water", "Food+Water", "Just-Bile"]},
              {:has_attribute, "Dog", "problem", :==, "Gastrointestinal"},
              {:has_attribute, "Anagrafic", "age", :==, "$age"},
              {:has_attribute, "Anagrafic", "age", :==, 1},
              {:has_attribute, "Anagrafic", "name", :==, "$name"}
            ]} ==
             Sanskrit.parse(text)
  end

  test "can parse is_not" do
    text = """
    $name is_notPerson
    """

    assert {:ok, [{:not, "$name", "Person"}]} ==
             Sanskrit.parse(text)

    text = """
    $name is_not "Person"
    """

    assert {:ok, [{:not, "$name", "Person"}]} ==
             Sanskrit.parse(text)
  end

  test "can parse a negative number" do
    text = """
    Person's age is -10
    """

    assert {:ok, [{:wme, "Person", "age", -10}]} ==
             Sanskrit.parse(text)
  end

  test "can no existing attribues" do
    text = """
    Person's name is unknown
    """

    assert {:ok, [{:not_existing_attribute, "Person", "name"}]} ==
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

  describe "parse functions" do
    test "variable args" do
      assert {:ok, [{:fun, "$name", "surname_of", ["$sinisi"]}]} =
               parse("""
               let $name = surname_of($sinisi)
               """)
    end

    test "integer literal args" do
      assert {:ok, [{:fun, "$result", "div", [10, 5]}]} =
               parse("""
               let $result = div(10, 5)
               """)
    end

    test "float literal args" do
      assert {:ok, [{:fun, "$result", "div", [10.1, 5.3]}]} =
               parse("""
               let $result = div(10.1, 5.3)
               """)
    end

    test "string literal args" do
      assert {:ok, [{:fun, "$result", "myfunc", ["yo", "dude"]}]} =
               parse("""
               let $result = myfunc("yo", "dude")
               """)
    end

    test "mixed literal args" do
      assert {:ok, [{:fun, "$result", "myfunc", ["yo", 12, 42.66, "$var"]}]} =
               parse("""
               let $result = myfunc("yo", 12, 42.66, $var)
               """)
    end
  end

  test "can parse Wme" do
    assert {:ok, [{:wme, "Person", "surname", "sinisi"}]} =
             parse("""
             Person's surname is "sinisi"
             """)
  end

  test "fails when a has attribute is not complete" do
    assert {:error, "Expected end of input at line 4, column 0"} =
             parse("""
             Person's surname is "sinisi"
             Person's age is 28
             Person's country is "Germany"
             Person's language is equal
             Germany's language is equal "german"
             """)
  end

  test "can parse a combination of HasAttribute, Wme and NewLines" do
    assert {:ok,
            [
              {:wme, "Person", "surname", "sinisi"},
              {:wme, "Person", "age", 28},
              {:wme, "Person", "country", "Germany"},
              {:has_attribute, "Person", "language", :==, "italian"},
              {:has_attribute, "Germany", "language", :==, "german"}
            ]} =
             parse("""
             Person's surname is "sinisi"
             Person's age is 28
             Person's country is "Germany"
             Person's language is equal "italian"
             Germany's language is equal "german"
             """)
  end

  test "can parse all statements" do
    assert {:ok,
            [
              {:isa, "$name", "Person"},
              {:wme, "Person", "surname", "sinisi"},
              {:wme, "Person", "age", 28},
              {:wme, "Person", "country", "Germany"},
              {:has_attribute, "Person", "language", :==, "italian"},
              {:has_attribute, "Germany", "language", :==, "german"},
              {:fun, "$surname", "surname_of", ["$sinisi"]},
              {:filter, "$surname", :==, "ciao"},
              {:not, "$x", "Duck"},
              {:not_existing_attribute, "Dog", "age"}
            ]} =
             parse("""
             $name isa Person
             Person's surname is "sinisi"
             Person's age is 28
             Person's country is "Germany"
             Person's language is equal "italian"
             Germany's language is equal "german"
             let $surname = surname_of($sinisi)
             when $surname equal "ciao"
             $x is_not Duck
             Dog's age is unknown
             """)
  end
end
