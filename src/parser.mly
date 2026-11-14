%{
open Lang
%}

%token <int> INT
%token <string> ID
%token TRUE
%token FALSE
%token TIMES
%token PLUS
%token LPAREN
%token RPAREN
%token COMMA
%token COLON
%token ARROW
%token INT_TYPE
%token BOOL_TYPE
%token LET
%token EQUALS
%token IN
%token IF
%token THEN
%token ELSE
%token FUN
%token FIX
%token FST
%token SND
%token EOF

%nonassoc IN
%nonassoc ELSE
%nonassoc ARROW
%right ARROW
%left EQUALS
%left PLUS
%left TIMES

%start <Lang.expr> prog

%%

prog:
  | e = expr; EOF { e }
  ;

expr:
  | i    = INT { Int i }
  | x    = ID  { Var x }
  | TRUE       { Bool true }
  | FALSE      { Bool false }
  | e1 = expr; EQUALS; e2 = expr { Equal (e1, e2) }
  | e1 = expr; TIMES;  e2 = expr { Mult(e1, e2) }
  | e1 = expr; PLUS;   e2 = expr { Plus(e1, e2) }
  | LET; x = ID; EQUALS; e1 = expr; IN; e2 = expr   { Let (x, e1, e2) }
  | IF; e1 = expr; THEN; e2 = expr; ELSE; e3 = expr { If (e1, e2, e3) }
  | LPAREN; e=expr; RPAREN {e}
  ;

atom_expr:
  | i = INT  { Int i }
  | x = ID   { Var x }
  | TRUE     { Bool true }
  | FALSE    { Bool false }
  (*Pair)*)
  | LPAREN; e1 = expr; COMMA; e2 = expr; RPAREN { Pair (e1, e2) }
  (*Parens*)
  | LPAREN; e = expr; RPAREN { e }
  ;