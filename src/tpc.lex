%{
/* tpc.lex */
#include "tpc.tab.h"
int cmp_ligne = 1;
#define KRED  "\x1B[31m"
#define KWHT  "\x1B[0m"
%}

%option nounput
%option noinput

%x commentaire


%%
\n 									cmp_ligne++;
\\\n 								cmp_ligne++;

"/*" 								BEGIN(commentaire);
<commentaire>"*"+"/" 				BEGIN(INITIAL);
<commentaire>. ;
<commentaire>\n 					cmp_ligne++;
"//"+.*\n 							cmp_ligne++;

"int"|"char" 						{strcpy(yylval.type, yytext) ;return TYPE;}	
if 									return IF;
else 								return ELSE;
return 								return RETURN;		
while 								return WHILE;		
do 									return DO;	
case 								return CASE;	
default 							return DEFAULT;	
switch 								return SWITCH;		
for 								return FOR;		
print 								return PRINT;	
readc 								return READC;	
reade 								return READE;	
void 								return VOID;	
const 								return CONST;
value 								return VALUE;
break 								return BREAK;		
	
\'[^'\\]\' 							return CARACTERE; /*ecriture dans yylval a add*/
\'\\['0btn]\' 						return CARACTERE;
[0-9]+ 								{sscanf(yytext, "%d", &(yylval.num)); return NUM;}	
[a-zA-Z_][_a-zA-Z0-9]*  			{strcpy(yylval.ident, yytext) ;return IDENT;}
						
"=="|"!=" 							{strcpy(yylval.eq, yytext);return EQ;}			
"+"|"-"|"+="|"-=" 					{strcpy(yylval.addsub, yytext);return ADDSUB;}					
"/="|"%="|"*="|"/"|"%"|"*" 			{strcpy(yylval.divsub, yytext) ;return DIVSTAR;}	
"<"|"<="|">"|">=" 					{strcpy(yylval.order, yytext);return ORDER;}
	
"||" 								return OR;		
"&&" 								return AND;

[\[\](){};,=!:] 					return yytext[0]; /*Autre truc autorisé*/


[ \t] /*truc qu'on ignore plus ou moins*/
. fprintf(stderr, "Unrecognized caracter [%s%c%s] ",KRED, yytext[0],KWHT); return yytext[0]; /*Truc pas autorisé*/


%%

