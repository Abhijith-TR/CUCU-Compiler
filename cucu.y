%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int a;
#define YYSTYPE char*
extern "C" int yylex();
int yyparse();
int flag = 0;
FILE* ptr,*parse;

void yyerror(const char* str) {
	if (!strcmp("Lexical Error",str)) {
		fprintf(ptr,"\nLine number: %d\n",a);
		fprintf(ptr,"Lexical Error\n");
	}
	else {
		fprintf(parse,"\nLine number: %d\n",a);
		fprintf(parse,"Syntax Error\n");
	}
	exit(0);
}

int yywrap() {
	return 1;
}

int main(int argc, char** argv) {
	a = 1;
	extern FILE* yyin, *yyout;
	yyin = fopen(argv[1],"r");
	parse = fopen("Parser.txt","w");
	ptr = fopen("Lexer.txt","w");
	yyparse();
	return 0;
}
%}

%token TYPE ID NUMBER OPAREN EPAREN COMMA OBRACK EBRACK OBRACE EBRACE ASSIGN EQUAL NOTEQUAL SUB DIV MULTIPLY ADD SEMI AND LE GE GREATER LESSER IF ELSE WHILE FOR RETURN OR STRING BOOLOR BOOLAND NEWLINE

%%
program: 
	statements
	;

statements: 
	var_dec statements 
	|
	function_declaration statements
	|
	function_definition statements
	|
	;
	
var_dec: 
	TYPE ID SEMI 									{fprintf(parse,"global-variable: %s\n\n",$2);}
	|
	TYPE ID ASSIGN expression SEMI 					{fprintf(parse,"operation: %s\nglobal-variable: %s\n\n",$3,$2);}
	|
	var_dec_new COMMA ID ASSIGN expression SEMI		{fprintf(parse,"operation: %s\nglobal-variable: %s\n\n",$4,$3);}
	|
	var_dec_new COMMA ID SEMI						{fprintf(parse,"global-variable: %s\n\n",$3);}
	;
	
var_dec_new:
	var_dec_new COMMA ID ASSIGN expression			{fprintf(parse,"operation: %s\nglobal-variable: %s\n",$4,$3);}
	|
	var_dec_new ID COMMA 							{fprintf(parse,"global-variable: %s\n",$3);}
	|
	TYPE ID ASSIGN expression 						{fprintf(parse,"operation: %s\nglobal-variable: %s\n",$3,$2);}
	|
	TYPE ID 										{fprintf(parse,"global-variable: %s\n",$2);}
	;
	
variable_declaration:
	TYPE ID 										{fprintf(parse,"local-variable: %s\n",$2);}
	|
	TYPE ID ASSIGN expression 						{fprintf(parse,"operation: %s\nlocal-variable: %s\n",$3,$2);}
	|
	cont_var_dec COMMA ID ASSIGN expression 		{fprintf(parse,"operation: %s\nlocal-variable: %s\n",$4,$3);}
	|
	cont_var_dec COMMA ID 							{fprintf(parse,"local-variable: %s\n",$3);}
	;
	
cont_var_dec: 
	cont_var_dec COMMA ID ASSIGN expression 		{fprintf(parse,"operation: %s\nlocal-variable: %s\n",$4,$3);}
	|
	cont_var_dec COMMA ID 							{fprintf(parse,"local-variable: %s\n",$3);}
	|
	TYPE ID ASSIGN expression 						{fprintf(parse,"operation: %s\nlocal-variable: %s\n",$3,$2);}
	| 
	TYPE ID 										{fprintf(parse,"local-variable: %s\n",$2);}
	;
	
expressions:
	expressions COMMA expression 					{fprintf(parse," FUNC-ARG\n");} 
	|
	expression 										{fprintf(parse," FUNC-ARG\n");}
	;

expression:
	expression BOOLOR or_exp 						{fprintf(parse,"operation: %s ",$2);}
	|
	or_exp
	;
	
or_exp:
	or_exp BOOLAND bool_exp 						{fprintf(parse,"operation: %s ",$2);}
	|
	bool_exp
	;
	
bool_exp:
	bool_exp AND rel_exp 							{fprintf(parse,"operation: %s ",$2);}
	|
	bool_exp OR rel_exp 							{fprintf(parse,"operation: %s ",$2);}
	|
	rel_exp 
	;
	
rel_exp:
	rel_exp EQUAL ar_exp 							{fprintf(parse,"operation: %s ",$2);}
	|
	rel_exp NOTEQUAL ar_exp 						{fprintf(parse,"operation: %s ",$2);}
	|
	rel_exp LE ar_exp 								{fprintf(parse,"operation: %s ",$2);}
	|
	rel_exp GE ar_exp 								{fprintf(parse,"operation: %s ",$2);}
	|
	rel_exp GREATER ar_exp 							{fprintf(parse,"operation: %s ",$2);}
	|
	rel_exp LESSER ar_exp 							{fprintf(parse,"operation: %s ",$2);}
	|
	ar_exp
	;
	
ar_exp:
	ar_exp ADD mul_exp 								{fprintf(parse,"operation: %s ",$2);}
	|
	ar_exp SUB mul_exp 								{fprintf(parse,"operation: %s ",$2);}
	|
	mul_exp
	;
	
mul_exp:
	mul_exp MULTIPLY ind_exp 						{fprintf(parse,"operation: %s ",$2);}
	|
	mul_exp DIV ind_exp 							{fprintf(parse,"operation: %s ",$2);}
	|
	ind_exp
	;
	
ind_exp:
	final 
	|
	ID OBRACK expression EBRACK 					{fprintf(parse," operation: []\nstring-var: %s ",$1);}
	|
	ID OPAREN expressions EPAREN 					{fprintf(parse,"FUNCTION-CALL: %s ",$1);}
	;
	
final:
	NUMBER 											{fprintf(parse,"const: %s ",$1);}
	|
	ID 												{fprintf(parse,"var: %s ",$1);}
	|
	STRING 											{fprintf(parse,"string: %s ",$1);}
	|
	OPAREN expression EPAREN 						{fprintf(parse,"parenthesis: () ");}
	;	
	
function_declaration:
	TYPE ID OPAREN arguments EPAREN SEMI 			{fprintf(parse,"FUNCTION-DECLARATION\nidentifier: %s\n\n",$2);}
	|
	TYPE ID OPAREN EPAREN SEMI						{fprintf(parse,"FUNCTION-DECLARATION\nidentifier: %s\n\n",$2);}
	;
	
arguments:
	TYPE ID 										{fprintf(parse,"var: %s FUNC-ARG\n",$2);} 
	|
	TYPE ID COMMA arguments 						{fprintf(parse,"var: %s FUNC-ARG\n",$2);} 
	;
	
function_definition:
	TYPE ID OPAREN arguments EPAREN OBRACE body EBRACE {fprintf(parse,"FUNCTION-BODY\nidentifier: %s\n\n",$2);}
	|
	TYPE ID OPAREN EPAREN OBRACE body EBRACE 		{fprintf(parse,"FUNCTION-BODY\nidentifier: %s\n\n",$2);}
	;
	
body: 
	variable_declaration SEMI body 
	|
	assignment SEMI body 
	|
	function_call SEMI body 
	|
	return SEMI body 
	|
	if_else body 
	|
	while body
	|
	;
	
assignment:
	ID ASSIGN expression 							{fprintf(parse,"operation: %s\nlocal-variable: %s \n",$2,$1);}
	;
	
function_call:
	ID OPAREN expressions EPAREN 					{fprintf(parse,"FUNCTION-CALL\nidentifier: %s\n\n",$1);}
	|
	ID OPAREN EPAREN 								{fprintf(parse,"FUNCTION-CALL\nidentifier: %s\n\n",$1);}
	;
	
return:
	RETURN expression 								{fprintf(parse,"RETURN\n");}
	;
	
if_else:
	IF OPAREN if_exp EPAREN OBRACE if_body EBRACE 	{fprintf(parse,"IF-STATEMENT\n\n");}
	|
	IF OPAREN if_exp EPAREN OBRACE if_body EBRACE ELSE OBRACE else_body EBRACE {fprintf(parse,"IF-ELSE STATEMENT\n\n");}
	;
	
if_exp:
	expression 										{fprintf(parse," IF-EXPRESSION\n");}
	;
	
if_body:
	body 											{fprintf(parse,"IF-BODY\n");}
	;
	
else_body:
	body 											{fprintf(parse,"ELSE-BODY\n");}
	;
	
while: 
	WHILE OPAREN while_exp EPAREN OBRACE body EBRACE {fprintf(parse,"WHILE-LOOP\n");}
	;
	
while_exp:
	expression 										{fprintf(parse,"WHILE-CONDITION\n");}
	;
%%
