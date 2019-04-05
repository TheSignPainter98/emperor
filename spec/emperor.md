# Emperor

## * Introduction

## * Feature List

## Emperor

- nice warning and error output 
- automatic parallelisation of tasks through separate spawned queues
- Packages (accessed by dot notation) have constants and pure functions, are syntactic sugar for sole classes—dependencies are superclasses
- Objects have constants and pure functions and multiple inheritance, functions can be overridden and inherited; accessible by dot notation
    - Constructor has separate name
- Set/range types tuples, parametric types
- Procedural constructs: `if`, `while`, `for`, `foreach`
- functions can have optional arguments (must have specified default value)
- Packages can be included with aliases
- Constants can be passed by reference, variables passed by copy to pure functions
- Impure functions may only be called from other, impure functions.
- The entry-point can either be pure or impure
- Inheritance and Interfaces
  - Pattern-matching through inheritance
  - Implementors available for default interface actions
  - Exceptions are not a thing! Just alternative return-types which _must_ be pattern-matched.
- Compile-Time Extensions—scripts which can generate code to compile—note that this may only be done in new files according to an API for the AST

## Standard Library Contents

- Maths
- CSV parser
- JSON Parser
- Data-structures
	- Collections
		- List
		- Set
		- Map
	- Iterators
		- Group iterators (returns a list of elements (presents))
- Framework for unit-testing

## Example syntax:

### Let

		<type> <const> <- <expression>

		<type> <variable> <- <expression>

### Pure Function

		<modifier> pure asdf(...) -> .:
				...
				return .

### Impure Functions
		<modifier> impure func asdf(...) -> :
				...
				return .

