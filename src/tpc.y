%{
/* tpc.y */
#include <stdio.h>
#include <ctype.h>
int yylex();
void yyerror(const char* s);
extern int cmp_ligne;
int error_code = 0;
%}

%expect 1
%define parse.error verbose

%union{
	char caractere;
	int num;
	char ident[65];
	char type[5];
	char eq[3];
	char order[3];
	char addsub[3];
	char divsub[3];
}

%token <caractere> CARACTERE 
%token <num> NUM 
%token <ident> IDENT 
%token <type> TYPE
%token <eq> EQ
%token <order> ORDER
%token <addsub> ADDSUB
%token <divstar> DIVSTAR

%token  OR
%token  AND 
%token  RETURN
%token  BREAK
%token  IF
%token  ELSE
%token  WHILE
%token  READE
%token  READC
%token  VOID
%token  PRINT
%token  CONST
%token  DO
%token  FOR
%token  SWITCH
%token  CASE
%token  DEFAULT
%token  VALUE

%%
Prog:  DeclConsts DeclVars DeclFoncts 
    ;
DeclConsts:
        DeclConsts CONST ListConst ';' 
    |   DeclConsts error ListConst ';' 
    |   DeclConsts CONST error ';' 
    |  ;
ListConst:
       ListConst ',' IDENT '=' Litteral 
    |  ListConst error IDENT '=' Litteral 
    |  ListConst ',' error '=' Litteral 
    |  ListConst ',' IDENT error Litteral 
    |  ListConst ',' IDENT '=' error 
    |  IDENT '=' Litteral 
    |  IDENT error Litteral 
    |  IDENT '=' error 
    |  error '=' Litteral 
    ;
Litteral:
       NombreSigne 
    |  CARACTERE 
    ;
NombreSigne:
       NUM 
    |  ADDSUB NUM 
    ;
DeclVars:
       DeclVars TYPE Declarateurs ';' 
    |  ;
Declarateurs:
       Declarateurs ',' Declarateur 
    |  Declarateur 
    ;
Declarateur:
       IDENT 
    |  error
    |  Declarateur '[' NUM ']'  /*MODIFIER*/
    ;
DeclFoncts:
       DeclFoncts DeclFonct 
    |  DeclFonct 
    ;
DeclFonct:
       EnTeteFonct Corps 
    ;
EnTeteFonct:
       TYPE IDENT '(' Parametres ')' 
    |  VOID IDENT '(' Parametres ')' 
    ;
Parametres:
       VOID 
    |
    |  ListTypVar 
    ;
Identtab: /*ajouter*/
	   IDENT '[' ']'
	 | Identtab '[' ']'
	 | Identtab error ']'
	 | Identtab error error
	 ;
ListTypVar:
       ListTypVar ',' TYPE IDENT 
    |  TYPE IDENT 
    |  TYPE Identtab /*modifier*/
    ;
Corps: '{' DeclConsts DeclVars SuiteInstr '}' 
    ;
SuiteInstr:
       SuiteInstr Instr 
    |  ;
Instr:
       Exp ';'
    |  ';' 
    |  RETURN Exp ';' 
    |  RETURN ';' 
    |  READE '(' IDENT ')' ';'
    |  READC '(' IDENT ')' ';'
    |  PRINT '(' Exp ')' ';'
    |  IF '(' Exp ')' Instr 
    |  IF '(' Exp ')' Instr ELSE Instr
    |  WHILE '(' Exp ')' Instr
    |  '{' SuiteInstr '}' 
    |  DO Instr WHILE '(' Exp ')' ';' /*Ajouté*/
    |  FOR '(' ListExpF ';' ExpF ';' ListExpF ')' Instr /*Ajouté*/
    |  SWITCH '(' Exp ')'  '{' Caseswitchs Defaultswitch '}' /*Ajouté*/
    ;
FinCase: /*Ajouté*/
	   BREAK ';'
	| 
	;
Caseswitch: /*Ajouté*/
	   CASE '(' Litteral ')' ':' Instr FinCase
	;
Defaultswitch: /*Ajouté*/
	   DEFAULT ':' Instr
	|
	;
Caseswitchs: /*Ajouté*/
	 Caseswitch
	| Caseswitchs Caseswitch
	;
ListExpF: /*Ajouté*/
	   ListExp
	|
	;
ExpF: /*Ajouté*/
	   Exp
	|
	;
Exp :  LValue '=' Exp 
    |  EB 
    ; 
EB  :  EB OR TB 
    |  TB 
    ;
TB  :  TB AND FB 
    |  FB 
    ;
FB  :  FB EQ M 
    |  M
    ;
M   :  M ORDER E 
    |  E 
    ;
E   :  E ADDSUB T 
    |  T 
    ;    
T   :  T DIVSTAR F 
    |  F 
    ;
F   :  ADDSUB F 
    |  '!' F 
    |  '(' Exp ')' 
    |  LValue  
    |  NUM 
    |  CARACTERE 
    |  IDENT '(' Arguments  ')' 
    |  StructValue /*Ajouté*/
    ;
StructValue: VALUE '(' Exp ')' '{' Valueargs Defaultvalue '}' /*Ajouté*/
	;
Valuearg: Litteral ':' Exp ';' /*Ajouté*/
	;
Valueargs: Valueargs Valuearg
	|  Valuearg
	;
Defaultvalue: DEFAULT ':' Exp ';' /*Ajouté*/
	;
LValue:
       IDENT 
    |  LValue  '[' Exp  ']'    /*MODIFIER*/
    ;
Arguments:
       ListExp 
    | ;
ListExp:
       ListExp ',' Exp 
    |  Exp 
    ;

%%

 
void yyerror(const char* s){
	fprintf(stderr, "%s\nline %d\n", s, cmp_ligne);
	error_code += 1;
}

int main(void){
	yyparse();
	return error_code;
}

