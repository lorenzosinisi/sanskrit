# Sanskrit

**A language to parse and integrate Retex**

```
 Dog isa $x
 Lorenzo's dog is $dog 
 Lorenzo's age is 28
 Lorenzo's country is "Germany"
 Lorenzo's language is equal "italian"
 Germany's language is equal "german"
 let $surname = surname_of($sinisi)
 when $surname equal "ciao"
 $x is_not Duck
 Dog's age is unknown
```


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

