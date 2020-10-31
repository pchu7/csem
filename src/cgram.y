%{
  /* grammar for subset of C. The grammar does not recognize all C syntax:
     For example:
     1. Character literals
     2. Structres
     3. Double constants
     4. Nested paraenthesis of the form "if((x == 1))"
     5. etc.
  */
#include <stdio.h>
#include <stdlib.h>

extern "C" {
    #include "cc.h"
    #include "scan.h"
    #include "semutil.h"
    #include "sem.h"
    #include "sym.h"
}

int yylex();

extern int lineno;
/*
 * yyerror - issue error message
 */
void
yyerror (const char *msg)
{
   fprintf(stderr, " %s.  Line %d\n", msg, lineno);
   exit(1);
}

%}
%union {
    int inttype;
    void *bb_ptr;
    
    char *str_ptr;
    struct sem_rec *rec_ptr;
    struct id_entry *id_ptr;
}

%token <str_ptr> ID CON STR
%token CHAR ELSE FLOAT DOUBLE FOR IF INT RESERVED RETURN WHILE DO CONTINUE BREAK GOTO
%right LVAL
%right SET SETOR SETXOR SETAND SETLSH SETRSH SETADD SETSUB SETMUL SETDIV SETMOD
%left  OR
%left  AND
%left  BITOR
%left  BITXOR
%left  BITAND
%left  EQ NE
%left  GT GE LT LE
%left  LSH RSH
%left  ADD SUB
%left  MUL DIV MOD
%right UNARY NOT COM
%type <rec_ptr> lval expr expro exprs cexpr n
%type <rec_ptr> cexpro prog
%type <id_ptr> dcl dclr fname
%type <inttype> type
%type <bb_ptr> lblstmt labels m
%%
prog    : externs		{}
        ;

externs :			{}
        | externs extern	{}
        ;

extern  : dcl ';'		{}				
        | func			{}
        ;

dcls    :			{}
        | dcls dcl ';'		{}
        ;

dcl     : type dclr             { $$ = dcl($2, $1, 0); }
        | dcl ',' dclr          { $$ = dcl($3, $1->i_type&~T_ARRAY, 0); }
        ;

dclr    : ID                    { $$ = dclr($1, 0, 1); }
        | ID '[' ']'            { $$ = dclr($1, T_ARRAY, 1); }
        | ID '[' CON ']'        { $$ = dclr($1, T_ARRAY, atoi($3)); }
        ;

type    : CHAR                  { $$ = T_INT; }
        | FLOAT                 { $$ = T_DOUBLE; }
        | DOUBLE                { $$ = T_DOUBLE; }
        | INT                   { $$ = T_INT; }
        ;

func    : fhead stmts '}'	{ ftail(); }
        ;

fhead   : fname fargs '{' dcls  { fhead($1); }
        ;

fname   : type ID               { $$ = fname($1, $2); }
        | ID                    { $$ = fname(T_INT, $1); }
        ;

fargs   : '(' ')' 		{ enterblock(); }
        | '(' args ')' 		{ enterblock(); }
        ;

args    : type dclr		{ dcl($2, $1, PARAM); }
        | args ',' type dclr	{ dcl($4, $3, PARAM); }
        ;

s	:			{ startloopscope(); }
	;

m       :                       { $$ = m(); }
        ;

n       :                       { $$ = n(); }
        ;

block   : '{' stmts '}'         { }
        ;

stmts   :			{ }
	| stmts lblstmt		{ }
        ;

lblstmt	: b stmt		{ }
	| b labels stmt		{ }
	;

labels	: ID ':'		{ labeldcl($1); }
	| labels ID ':'		{ labeldcl($2); }
	;

b	: 			{ }
	;

stmt    : expr ';'
                { }
        | IF '(' cexpr ')' m lblstmt m
                { doif($3, $5, $7); }
        | IF '(' cexpr ')' m lblstmt ELSE n m lblstmt m
                { doifelse($3, $5, $8, $9, $11); }
        | WHILE '(' m cexpr ')' m s lblstmt n m
                { dowhile($3, $4, $6, $9, $10); }
        | DO m s lblstmt WHILE '(' m cexpr ')' ';' m
                { dodo($2, $7, $8, $11); }
        | FOR '(' expro ';' m cexpro ';' m expro n ')' m s lblstmt n m
                { dofor($5, $6, $8, $10, $12, $15, $16); }
	| CONTINUE ';'
		{ docontinue(); }
	| BREAK ';'
		{ dobreak(); }
	| GOTO ID ';'
		{ dogoto($2); }
        | RETURN ';'
                { doret((struct sem_rec *) NULL); }
        | RETURN expr ';'
                { doret($2); }
	| block
		{ }
        | ';'
                { }
        ;

cexpro  :			{ $$ = node(NULL, NULL, 0, NULL, n(), NULL); }
        | cexpr			{}
        ;

cexpr   : expr EQ expr          { $$ = rel((const char*) "==", $1, $3); }
        | expr NE expr          { $$ = rel((const char*) "!=", $1, $3); }
        | expr LE expr          { $$ = rel((const char*) "<=", $1, $3); }
        | expr GE expr          { $$ = rel((const char*) ">=", $1, $3); }
        | expr LT expr          { $$ = rel((const char*) "<",  $1, $3); }
        | expr GT expr          { $$ = rel((const char*) ">",  $1, $3); }
        | cexpr AND m cexpr     { $$ = ccand($1, $3, $4); }
        | cexpr OR m cexpr      { $$ = ccor($1, $3, $4); }
        | NOT cexpr             { $$ = ccnot($2); }
        | expr                  { $$ = ccexpr($1); }
        | '(' cexpr ')'         { $$ = $2; }
        ;

exprs   : expr                  { $$ = $1; }
        | exprs ',' expr        { $$ = exprs($1, $3); }
        ;

expro   :			{ }
        | expr			{ }
        ;

expr    : lval SET expr		{ $$ = set((const char*) "",   $1, $3); }
        | lval SETOR expr	{ $$ = set((const char*) "|",  $1, $3); }
        | lval SETXOR expr	{ $$ = set((const char*) "^",  $1, $3); }
        | lval SETAND expr	{ $$ = set((const char*) "&",  $1, $3); }
        | lval SETLSH expr	{ $$ = set((const char*) "<<", $1, $3); }
        | lval SETRSH expr	{ $$ = set((const char*) ">>", $1, $3); }
        | lval SETADD expr	{ $$ = set((const char*) "+",  $1, $3); }
        | lval SETSUB expr	{ $$ = set((const char*) "-",  $1, $3); }
        | lval SETMUL expr	{ $$ = set((const char*) "*",  $1, $3); }
        | lval SETDIV expr	{ $$ = set((const char*) "/",  $1, $3); }
        | lval SETMOD expr	{ $$ = set((const char*) "%",  $1, $3); }
        | expr BITOR expr	{ $$ = opb((const char*) "|",  $1, $3); }
        | expr BITXOR expr	{ $$ = opb((const char*) "^",  $1, $3); }
        | expr BITAND expr	{ $$ = opb((const char*) "&",  $1, $3); }
        | expr LSH expr		{ $$ = opb((const char*) "<<", $1, $3); }
        | expr RSH expr		{ $$ = opb((const char*) ">>", $1, $3); }
        | expr ADD expr		{ $$ = op2((const char*) "+",  $1, $3); }
        | expr SUB expr		{ $$ = op2((const char*) "-",  $1, $3); }
        | expr MUL expr		{ $$ = op2((const char*) "*",  $1, $3); }
        | expr DIV expr		{ $$ = op2((const char*) "/",  $1, $3); }
        | expr MOD expr		{ $$ = op2((const char*) "%",  $1, $3); }
        | BITAND lval %prec UNARY { $$ = $2; }
        | SUB expr %prec UNARY	{ $$ = op1((const char*) "-",      $2); }
        | COM expr		{ $$ = op1((const char*) "~",      $2); }
        | lval %prec LVAL	{ $$ = op1((const char*) "@",      $1); }
        | ID '(' ')'		{ $$ = call($1, (struct sem_rec *) NULL); }
        | ID '(' exprs ')'	{ $$ = call($1, $3); }
        | '(' expr ')'		{ $$ = $2; }
        | CON			{ $$ = con($1); }
        | STR			{ $$ = genstring($1); }
	;

lval	: ID			{ $$ = id($1); }
	| ID '[' expr ']'	{ $$ = indx(id($1), $3); }
        ;
%%



