# Sanskrit DSL

## Introduction
This DSL (Domain-Specific Language) provides a set of statements to define and manipulate data related to people, their attributes, and some filtering conditions. The DSL allows users to express relationships, properties, and constraints in a structured and readable format.

## DSL Statements

### `:isa`
The `:isa` statement defines the type of an entity. It associates a given `$name` with the type "Person". For example, `Person` is associated with the type "Person".

### `:wme`
The `:wme` statement defines a property of an entity. It specifies that the entity mentioned in the first argument (e.g., `Person`) has a certain attribute with a specific value. For example, `Person` has a surname "sinisi", an age of 28, and is from Germany.

### `:has_attribute`
The `:has_attribute` statement checks if a given entity has a certain attribute with a specific value. It compares the attribute value of an entity to the provided value using the specified comparison operator. For example, it checks if `Person` has a language attribute equal to "italian" and if `Germany` has a language attribute equal to "german".

### `:fun`
The `:fun` statement defines a function. It assigns the result of a function call to a variable. In this case, it assigns the result of the function `surname_of($sinisi)` to the variable `$surname`. The function `surname_of` takes the argument `$sinisi`.

### `:filter`
The `:filter` statement is used for filtering entities based on certain conditions. It checks if the value of the variable `$surname` is equal to "ciao". If the condition is true, the entity associated with the variable `$surname` passes the filter.

### `:not`
The `:not` statement negates a condition. It checks if the entity mentioned in the first argument (e.g., `$x`) is not equal to "Duck". If the condition is true, the entity passes the negated condition.

### `:not_existing_attribute`
The `:not_existing_attribute` statement checks if an entity does not have a specific attribute. It verifies if the entity mentioned in the first argument (e.g., "Dog") does not have the attribute "age".

## Example Usage

The provided DSL code is a representation of the statements explained above. It uses the DSL syntax to express various relationships and constraints related to entities.

```ruby
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
```

In this example, the DSL code describes a person named Person with a surname "sinisi" and an age of 28. Person is from Germany and speaks Italian. The DSL code assigns the result of the `surname_of($sinisi)` function to the variable `$surname`. It then checks if `$surname` is equal to "ciao". Additionally, it ensures that `$x` is not equal to "Duck". Finally, it checks if the attribute "age" does not exist for the entity "Dog".

Please note that this DSL code is an example, and the actual implementation or usage may vary depending on the specific DSL interpreter or framework used.

# Sanskrit DSL

## Introduction

Sanskrit is a domain-specific language designed to parse and integrate Retex. It provides a set of statements and data types to define and manipulate data in a structured and readable format.

## Concepts

### Data Types

Sanskrit supports the following data types:

- **String**: Represents text and is enclosed in double quotes (`"`).
- **Boolean**: Represents true or false.
- **Number**: Represents whole numbers.
- **Decimal Numbers**: Represents numbers with decimal points.
- **Context Value**: Represents external values that can be replaced at runtime, such as session IDs or tags. They are prefixed with a hash symbol (`#`).
- **Variable**: Represents a variable name and is prefixed with a dollar sign (`$`). Variables can be assigned values.
- **Array**: Represents a list of values, which can be strings or numbers, enclosed in square brackets (`[]`).

### Statements

Sanskrit supports the following statements:

- **Working Memory Element**: Defines a property of an entity in the working memory. It associates an entity with a specific attribute and value.
- **Has Attribute**: Checks if an entity has a specific attribute with a certain value. It compares the attribute value of an entity to the provided value using the specified comparison operator.
- **Is an Entity**: Specifies the type of an entity.
- **Is Not an Entity**: Negates the condition that an entity should be of a specific type.
- **Has No Attribute**: Checks if an entity does not have a specific attribute.
- **Filter**: Filters entities based on certain conditions.
- **Function**: Defines a function and assigns the result to a variable.

## Installation

To use Sanskrit, you can add it as a dependency in your `mix.exs` file:

```elixir
def deps do
  [
    {:sanskrit, git: "https://github.com/lorenzosinisi/sanskrit"}
  ]
end
```

You can also generate documentation for Sanskrit using ExDoc and publish it on HexDocs for reference. The documentation can be found at [https://hexdocs.pm/sanskrit](https://hexdocs.pm/sanskrit).



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

