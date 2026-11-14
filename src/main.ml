(* open Lang

let parse (s : string) : expr =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast *)

open Lang

let parse (s : string) : expr =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast

let () =
  let input = "Let x = 2 + 3 In x * 4" in
  let ast = parse input in
  print_endline ("Parsed AST: " ^ string_of_expr ast);
  print_endline ("Result: " ^ string_of_expr (multistep ast))