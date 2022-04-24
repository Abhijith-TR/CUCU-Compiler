%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char*
extern "C" int yylex();
#include "cucu.tab.h"
extern FILE* ptr;
extern int a;
void yyerror(const char* str);
%}

%%
<<EOF>> return 0;
\"([^\"])*\" 		                {yylval = strdup(yytext);fprintf(ptr,"STRING: %s\n",yytext);return STRING;}
(int|char[ ]*\*+|char)              {yylval = strdup(yytext);fprintf(ptr,"TYPE : %s\n",yytext);return TYPE;}
if                                  {yylval = strdup(yytext);fprintf(ptr,"IF: %s\n",yytext);return IF;}
else                                {yylval = strdup(yytext);fprintf(ptr,"ELSE: %s\n",yytext);return ELSE;}
while                               {yylval = strdup(yytext);fprintf(ptr,"WHILE: %s\n",yytext);return WHILE;}
for 			                    {yylval = strdup(yytext);fprintf(ptr,"FOR: %s\n",yytext);return FOR;}
return 		                        {yylval = strdup(yytext);fprintf(ptr,"RETURN: %s\n",yytext);return RETURN;}
[_a-zA-Z][a-zA-Z0-9_]*              {yylval = strdup(yytext);fprintf(ptr,"ID: %s\n",yytext);return ID;}
[0-9]+ 		                        {yylval = strdup(yytext);fprintf(ptr,"NUM: %s\n",yytext);return NUMBER;}
\( 			                        {yylval = strdup(yytext);fprintf(ptr,"LEFT PARENTHESIS: %s\n",yytext);return OPAREN;}
\) 			                        {yylval = strdup(yytext);fprintf(ptr,"RIGHT PARENTHESIS: %s\n",yytext);return EPAREN;}
, 			                        {yylval = strdup(yytext);fprintf(ptr,"COMMA: %s\n",yytext);return COMMA;}
\[ 			                        {yylval = strdup(yytext);fprintf(ptr,"LEFT BRACKETS: %s\n",yytext);return OBRACK;}
\] 			                        {yylval = strdup(yytext);fprintf(ptr,"RIGHT BRACKETS: %s\n",yytext);return EBRACK;}
\{ 			                        {yylval = strdup(yytext);fprintf(ptr,"LEFT BRACES: %s\n",yytext);return OBRACE;}
\} 			                        {yylval = strdup(yytext);fprintf(ptr,"RIGHT BRACES: %s\n",yytext);return EBRACE;}
(=) 			                    {yylval = strdup(yytext);fprintf(ptr,"ASSIGN: %s\n",yytext);return ASSIGN;}
(==) 			                    {yylval = strdup(yytext);fprintf(ptr,"EQUAL: %s\n",yytext);return EQUAL;}
&&			                        {yylval = strdup(yytext);fprintf(ptr,"AND: %s\n",yytext);return BOOLAND;}
\|\|			                    {yylval = strdup(yytext);fprintf(ptr,"OR: %s\n",yytext);return BOOLOR;}	
\!= 			                    {yylval = strdup(yytext);fprintf(ptr,"NOT EQUAL: %s\n",yytext);return NOTEQUAL;}
\- 			                        {yylval = strdup(yytext);fprintf(ptr,"SUBTRACT: %s\n",yytext);return SUB;}
\/ 			                        {yylval = strdup(yytext);fprintf(ptr,"DIVIDE: %s\n",yytext);return DIV;}
\* 			                        {yylval = strdup(yytext);fprintf(ptr,"MULTIPLY: %s\n",yytext);return MULTIPLY;}
\+ 			                        {yylval = strdup(yytext);fprintf(ptr,"PLUS: %s\n",yytext);return ADD;}
; 			                        {yylval = strdup(yytext);fprintf(ptr,"SEMI: %s\n",yytext);return SEMI;}
\| 			                        {yylval = strdup(yytext);fprintf(ptr,"BITWISE OR: %s\n",yytext);return OR;}
\>\= 			                    {yylval = strdup(yytext);fprintf(ptr,"GREATER THAN OR EQUAL: %s\n",yytext);return GE;}
\<\= 			                    {yylval = strdup(yytext);fprintf(ptr,"LESS THAN OR EQUAL: %s\n",yytext);return LE;}
\> 			                        {yylval = strdup(yytext);fprintf(ptr,"GREATER THAN: %s\n",yytext);return GREATER;}
\< 			                        {yylval = strdup(yytext);fprintf(ptr,"LESSER THAN: %s\n",yytext);return LESSER;}
\/\*[^(\*\/)]*\*\/ 		            ;
& 			                        {yylval = strdup(yytext);fprintf(ptr,"BITWISE AND: %s\n",yytext);return AND;}
[ \t]* 		                        ;
\n 			                        {a++;}
. 			                        {yyerror("Lexical Error");}
%%

