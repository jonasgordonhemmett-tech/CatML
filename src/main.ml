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

let () =
  let input = "Let x = 2 + 3 In x * 4" in
  let ast = parse input in
  print_endline ("Parsed AST: " ^ string_of_expr ast);
  print_endline ("Result: " ^ string_of_expr (multistep ast));
  let input2 = "Let sum = Fix (Fun f, (Int -> Int) -> Fun x, Int ->
  If x = 0 Then 0 Else x + (f (x + -1))) In sum 4" in
  let ast = parse input2 in
  print_endline ("Parsed AST: " ^ string_of_expr ast);
  print_endline ("Type of AST:" ^ string_of_type (type_of_expr_opt (empty_context, ast)));
  print_endline ("Result: " ^ string_of_expr (multistep ast))