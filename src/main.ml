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



let test_cases ()=
  print_endline ("Test!")

let () =
  (* do_stuff "Let x = 2 + 3 In x * 4";
  do_stuff "Let sum = Fix (Fun f, (Int -> Int) -> Fun x, Int ->
  If x = 0 Then 0 Else x + (f (x + -1))) In sum 4";
  do_stuff "(Fun f, (Int -> Int) -> Fun x, Int ->
  If x = 0 Then 0 Else x + (f (x + -1)))"; *)
  if Array.length Sys.argv > 1 then
    do_stuff (read_file Sys.argv.(1))
  else
    test_cases()