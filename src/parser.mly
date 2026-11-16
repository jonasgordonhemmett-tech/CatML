%{
open Lang
%}

%token <int> INT
%token <string> ID
%token TRUE
%token FALSE
%token TIMES
%token PLUS
%token AND
%token OR
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
%right ARROW
%left OR
%left AND
%nonassoc EQUALS
%left EQUALS
%left PLUS
%left TIMES
%nonassoc NOT
%nonassoc FST
%nonassoc SND
%nonassoc FIX
%left APP

%start <Lang.expr> prog

%%

prog:
  | e = expr; EOF { e }
  ;

tps:
  | INT_TP {INT}
  | BOOL_TP {BOOL}
  | t1 = tps; COMMA; t2 = tps {PAIR(t1, t2)}
  | t1 = tps; ARROW; t2 = typs {ARROW(t1, t2)}
  | LPAREN; t = tps; RPAREN {t}

expr:
  | i    = INT { Int i }
  | x    = ID  { Var x }
  | TRUE       { Bool true }
  | FALSE      { Bool false }
  | LPAREN; e1 = expr; COMMA; e2 = expr; RPAREN {Pair(e1, e2)} (*Pair*)
  | e1 = expr; APP; e2 = expr {App(e1, e2)}
  | NOT; e1 = expr {Not e1}
  | FST; e1 = expr {Fst e1}
  | SND; e1 = expr {Snd e1}
  | FIX; e1 = expr {Fix e1}
  | e1 = expr; AND; e2 = expr { And(e1, e2)}
  | e1 = expr; OR; e2 = expr { Or(e1, e2)}
  | e1 = expr; EQUALS; e2 = expr { Equal (e1, e2) }
  | e1 = expr; TIMES;  e2 = expr { Mult(e1, e2) }
  | e1 = expr; PLUS;   e2 = expr { Plus(e1, e2) }
  | LET; x = ID; EQUALS; e1 = expr; IN; e2 = expr   { Let (x, e1, e2) }
  | IF; e1 = expr; THEN; e2 = expr; ELSE; e3 = expr { If (e1, e2, e3) }
  | FUN; x = ID; COMMA; tp = tps; ARROW; e1 = expr {Fun(x, tp, e1)}
  | LPAREN; e1=expr; RPAREN {e1} (*Parens*) 
  
  ;
