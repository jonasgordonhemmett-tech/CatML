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
%token NOT
%token LPAREN
%token RPAREN
%token COMMA
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
%left PLUS
%left TIMES


%start <Lang.expr> prog

%%

prog:
  | e = expr; EOF { e }
  ;

tps:
  | INT_TYPE {INT}
  | BOOL_TYPE {BOOL}
  | t1 = tps; COMMA; t2 = tps {PAIR(t1, t2)}
  | t1 = tps; ARROW; t2 = tps {ARROW(t1, t2)}
  | LPAREN; tp = tps; RPAREN {tp}

expr:
  | e1 = atom_expr {e1}
  | e1 = expr; e2 = atom_expr {App(e1, e2)}
  | NOT; e1 = atom_expr {Not e1}
  | FST; e1 = atom_expr {Fst e1}
  | SND; e1 = atom_expr {Snd e1}
  | FIX; e1 = atom_expr {Fix e1}
  | e1 = expr; AND; e2 = expr { And(e1, e2)}
  | e1 = expr; OR; e2 = expr { Or(e1, e2)}
  | e1 = expr; EQUALS; e2 = expr { Equal (e1, e2) }
  | e1 = expr; TIMES;  e2 = expr { Mult(e1, e2) }
  | e1 = expr; PLUS;   e2 = expr { Plus(e1, e2) }
  | LET; x = ID; EQUALS; e1 = expr; IN; e2 = expr   { Let (x, e1, e2) }
  | IF; e1 = expr; THEN; e2 = expr; ELSE; e3 = expr { If (e1, e2, e3) }
  | FUN; x = ID; COMMA; tp = tps; ARROW; e1 = expr {Fun(x, tp, e1)}
  ;

atom_expr:
  | i = INT { Int i }
  | x = ID  { Var x }
  | TRUE { Bool true }
  | FALSE { Bool false }
  | LPAREN; e1 = expr; COMMA; e2 = expr; RPAREN {Pair(e1, e2)} (*Pair*)
  | LPAREN; e1=expr; RPAREN {e1} (*Parens*) 
