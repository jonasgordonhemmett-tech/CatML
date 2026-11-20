(* open Lang

let parse (s : string) : expr =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast *)


(*
dune build
dune exec ./src/main.exe
*)
(*https://ocaml.org/docs/file-manipulation*)
open CatML
open Lang
let parse (s : string) : expr =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast
let read_file str : string =
  In_channel.with_open_text str In_channel.input_all

let do_stuff str = 
  match parse str with
  | exception ex -> print_endline("AST could not be parsed!: " ^ Printexc.to_string ex)
  | ast ->
    print_endline ("Parsed AST: " ^ string_of_expr ast);
    print_endline ("Type of AST: " ^ string_of_type_opt (type_of_expr (empty_context, ast)));
    print_endline ("Result: " ^ string_of_expr (multistep ast))


let test_case (str, expected_parsed, expected_type, expected_result) = 
  match parse str with
  | exception ex ->
     print_endline ("\t" ^ str ^ ": " ^ "Failed");
      false
  | _ ->
  let ast = parse str in
    if string_of_expr ast = expected_parsed && 
    string_of_type_opt (type_of_expr (empty_context, ast)) = expected_type  &&
    string_of_expr (multistep ast) = expected_result
    then (
      print_endline ("\t" ^ str ^ ": " ^ "Passed");
      true)
    else (
      print_endline ("\t" ^ str ^ ": " ^ "Failed");
      false)

let test_cases () =
    print_endline("Test Cases:");
  (*Basic operations*)
  if test_case("True And True", "(True And True)", "Bool", "True")
  && test_case("False And True", "(False And True)", "Bool", "False")
  && test_case("False And False", "(False And False)", "Bool", "False")
  && test_case("True Or True", "(True Or True)", "Bool", "True")
  && test_case("True Or False", "(True Or False)", "Bool", "True")
  && test_case("False Or False", "(False Or False)", "Bool", "False")

  && test_case("Not True", "(Not True)", "Bool", "False")
  && test_case("Not False", "(Not False)", "Bool", "True")
  && test_case("Not 1", "(Not 1)", "Type Error", "(Not 1)")

  && test_case("1 + 2 + 3 + 4", "(((1 + 2) + 3) + 4)", "Int", "10")

  && test_case("1 + 2 And False", "((1 + 2) And False)", "Type Error", "(3 And False)")

  && test_case("(((((0)))))", "0", "Int", "0")

  (*Pairs*)
  && test_case("(True, 1)", "(True, 1)", "(Bool, Int)", "(True, 1)")
  
  && test_case("Fst (True, 1)", "Fst((True, 1))", "Bool", "True")
  && test_case("Fst(True And 1 + 2, 3)", "Fst(((True And (1 + 2)), 3))", "Type Error", "Fst(((True And 3), 3))")

  && test_case("Snd (True, 1)", "Snd((True, 1))", "Int", "1")
  && test_case("Snd(True And 1 + 2, 3)", "Snd(((True And (1 + 2)), 3))", "Type Error", "Snd(((True And 3), 3))")

  && test_case("Fst(1)", "Fst(1)", "Type Error", "Fst(1)")
  && test_case("Snd(True)", "Snd(True)", "Type Error", "Snd(True)")

  && test_case("If True Then 1 + 1 Else True And 1", "If True Then (1 + 1) Else (True And 1)", "Type Error", "2")

  (*Functions*)
  && test_case("Let f = Fun x, Int -> x + 1 In f 2", "Let f = (Fun x -> (x + 1)) In (f 2)", "Int", "3")


  && test_case("Let fact = Fix (Fun f, (Int -> Int) -> Fun n, Int ->
  If n = 0 Then 1 Else n * (f (n + -1))) In fact 4", "Let fact = Fix((Fun f -> (Fun n -> If (n = 0) Then 1 Else (n * (f (n + -1)))))) In (fact 4)", "Int", "24")


  && test_case("Fun x, Int -> x + 1", "(Fun x -> (x + 1))", "(Int -> Int)", "(Fun x -> (x + 1))")

  && test_case("Fix 1", "Fix(1)", "Type Error", "Fix(1)")

  then
    print_endline("\nTest Cases Passed")
  else
    print_endline("\nTest Cases Failed")

  



let () =
  if Array.length Sys.argv > 1 then
    do_stuff (read_file Sys.argv.(1))
  else
    test_cases ()