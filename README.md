# Sanskrit

**A language to parse and integrate Retex**

```elixir
  [
    {:isa, "$name", "Person"},
    {:wme, "Lorenzo", "surname", "sinisi"},
    {:wme, "Lorenzo", "age", 28},
    {:wme, "Lorenzo", "country", "Germany"},
    {:has_attribute, "Lorenzo", "language", :==, "italian"},
    {:has_attribute, "Germany", "language", :==, "german"},
    {:fun, "$surname", "surname_of", ["$sinisi"]},
    {:filter, "$surname", :==, "ciao"},
    {:not, "$x", "Duck"},
    {:not_existing_attribute, "Dog", "age"}
  ]} =
   parse("""
   $name isa Person
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
```

**Concepts:**

We have the following data types: 

- **String:** represent text and are sentences or words between double quotes `"`
- **Boolean:** `true` and `false` represent yes and no
- **Number:** `1`, `2` etc
- **Decimal numbers:** `1.0`, `2.322` etc
- **Context value:** `#sessionid`, `#tag` that represents external values that can be replaced at runtime
- **Variable:** `$this_is_a_variable`, `$this` which is a wildcart at which we assign a value if exists
- **Array:** `["Hello", 1, 1.0]`, which rapresents a list of values, strings or numbers


And the following statements:

- working memory element
- has attribute
- is a entity
- is not an entity
- has no attribute
- filter
- function




## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sanskrit` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sanskrit, git: "https://github.com/lorenzosinisi/sanskrit"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sanskrit](https://hexdocs.pm/sanskrit).

