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
  let ast = parse str in 
  print_endline ("Parsed AST: " ^ string_of_expr ast);
  print_endline ("Type of AST: " ^ string_of_type_opt (type_of_expr (empty_context, ast)));
  print_endline ("Result: " ^ string_of_expr (multistep ast))


let test_case (str, expected_parsed, expected_type, expected_result) = 
  let ast = parse str in let status = 
    if string_of_expr ast = expected_parsed && 
    string_of_type_opt (type_of_expr (empty_context, ast)) = expected_type  &&
    string_of_expr (multistep ast) = expected_result
    then 
      "Passed" 
  else 
    "Failed" 
  in print_endline (expected_parsed ^ ": " ^ status)

let test_cases () =
  test_case("1 + 2 + 3 + 4", "(((1 + 2) + 3) + 4)", "Int", "10");

  test_case("Let f = Fun x, Int -> x + 1 In f 2", "Let f = (Fun x -> (x + 1)) In (f 2)", "Int", "3");

  test_case("(True, 1)", "(True, 1)", "(Bool, Int)", "(True, 1)");
  
  test_case("Fst(True, 1)", "Fst((True, 1))", "Bool", "True");
  test_case("Let fact = Fix (Fun f, (Int -> Int) -> Fun n, Int ->
  If n = 0 Then 1 Else n * (f (n + -1))) In fact 4", "Let fact = Fix((Fun f -> (Fun n -> If (n = 0) Then 1 Else (n * (f (n + -1)))))) In (fact 4)", "Int", "24")



let () =
  if Array.length Sys.argv > 1 then
    do_stuff (read_file Sys.argv.(1))
  else
    test_cases ()