(*for /f "tokens=*" %i in ('opam env') do @%*)
{
open Parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let int = '-'? digit+
let letter = ['a'-'z' 'A'-'Z']
(* let id = letter+ *)
(* Allows number now *)
let id = letter (letter | digit | '_')*

rule read =
  parse
  | white { read lexbuf }
  | "True" { TRUE }
  | "False" { FALSE }
  | "*" { TIMES }
  | "+" { PLUS }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "Let" { LET }
  | "=" { EQUALS }
  | "In" { IN }
  | "If" { IF }
  | "Then" { THEN }
  | "Else" { ELSE }
  | "," { COMMA }
  | "Fst" {FST}
  | "Snd" {SND}
  | "Fun" {FUN}
  | "Fix" {Fix}
  | "->" {ARROW}\
  
  | id { ID (Lexing.lexeme lexbuf) }
  | int { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | eof { EOF }