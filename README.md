# Jonas Hemmett, Assignment 8, CS3250

This repository contains a (template) implementation of CatML, an ML variant used at UVM for CS3250.

## Building this repository with `dune`

This repository can be built with [`dune`](https://github.com/ocaml/dune), a build system for OCaml projects. It helps manage linking when your project is made up of multiple `.ml` files.

### Install `dune`

Check if dune is already installed via the following terminal command:

```
$ dune --version
```

If the command is not found, you can install it via `opam` [(detailed instructions)](https://dune.readthedocs.io/en/latest/howto/install-dune.html).

```
$ opam install dune
$ eval $(opam config env)
$ dune --version
```

### Build the project

With `dune` installed, you can build the project by running `dune build` from the command line.

```
$ dune build
```

You can also access the project modules by running `dune utop`, which will build the project and then open the `utop` toplevel. Different files (such as `src/lang.ml`) correspond to OCaml modules, and data structures (such as the `Var` constructor in the CatML AST) can be accessed via `CatML.Lang.Bool`, where `CatML` is the overall name of the project.

### Structure of the repository

```
- <root>
  - dune-project
  - src
    - dune
    - lang.ml
    - lexer.mll
    - parser.mly
    - main.ml
  - examples
    - example.catml
    - factorial.catml
```

The `dune-project` plaintext file at the top level tells dune how to build your project. The file `src/dune` tells dune the name of the library (`CatML`) and the fact that we have a ocamllex file `lexer.mll` and a menhir parser specification file `parser.mly` in the `src` subdirectory.

```
(library (name CatML))
(menhir (modules parser))
(ocamllex lexer)
```

The files in the `src` directory include:

- `lang.ml`: The main definition of the CatML language, including syntax, evaluation, and type checking
- `lexer.mll`: The specification of the lexer used by ocamllex
- `parser.mly`: The specification of the parser used by menhir
- `main.ml`: Demonstration of how to access the lexer and parser generated from the above files

In the `examples` directory I have included two sample CatML programs. You should write your own additional CatML programs to test your work.

## Other Resources

1. Parsing and lexing generators in OCaml, [OCaml Programming, Correct + Efficient + Beautiful](https://cs3110.github.io/textbook/chapters/interp/parsing.html)
2. Parsing with OCamllex and Menhir, [Real World OCaml](https://dev.realworldocaml.org/parsing-with-ocamllex-and-menhir.html)
3. [Dune build system reference](https://github.com/ocaml/dune)

## How to interact with a CatML program

Running [run.py](run.py) will allow you to easily interact with CatML. This program might get flagged by your antivirus software, you may need to override it.

main.ml can also be ran directly through powershell:
* Run ```(& opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }```
* Run ```dune build```
* Run ```dune exec ./src/main.exe --``` to run test cases
* Run ```dune exec ./src/main.exe -- data/expr_file.txt``` to process an AST, [expr_file.txt](data/expr_file.txt) can be replaced with any AST file in [data](data)

# Reflection Questions

1. If you worked as a group, list all the group members.

N/A

2. Did you use generative AI to assist you in implementing this project? If so, briefly explain how you used it and for which components.

I used Gemini to help debug issue in lexer.mll, parser.mly, and run.py. I found it very helpful as I was able to rapidly fix issues.

3. Did you make any design decisions that we should know about?

I required functions to take in a type as input. Without this, functions such as $Fun(x) → x$ would require evaluation to type check. This means functions are now written like ```Let f = Fun x, Int -> x + 1 In f 2``` in CatML.

4. Did you implement any of the extra credit features? Briefly summarize your work.

I added a detailed test suite to test the parser, evaluator, and type-checker.

I also build a Pyhton program [run.py](run.py) which allows you to easily create ASTS, process them through main.ml, and run test cases.

5. Any feedback on the structure of this assignment?

N/A