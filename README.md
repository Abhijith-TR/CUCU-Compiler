# CUCU-Compiler

Done by - Abhijith T R
Entry no - 2020CSB1062

To compile the program, run the following commands
flex cucu.l;
bison -d cucu.y;
g++ cucu.tab.c lex.yy.c -lfl -o cucu;

./cucu filename.cu

Sample1.cu is the .cu file which is entirely syntactically correct.
Sample2.cu contains errors at lines 1 (declaration without type),5(expression on the LHS) and 6(missing '}').

Assumptions
1. All assumptions mentioned in the assignment pdf hold here.
2. The parser and lexer will stop working as soon as the first error is detected. If the error is with a token, the output will be lexical error in Lexer.txt along with the line number and the unrecognised token. If the error is with the syntax, the output will be syntax error in Parser.txt along with the line number. Parser.txt and Lexer.txt will contain the output until the error was detected. 
3. Do not include any * or / symbols inside the comments
4. Check the end of both files to check if there are any errors. Fix the error and run ./cucu filename.cu again to get the next error and continue till the program is error free. 
5. The missing semicolon error will be displayed when the next token is recieved, so the line number will be that of the line with the next token.
6. Both if-else and plain if statements are allowed. 
7. The line numbers being displayed may not be on the exact line. This is because the next token may or may not have been received on the same line.
8. Variables declared outside functions are global, while variables inside functions are local.
9. Valid operators are: + - * / & | && || < > <= >= == !=
10. Strings will be matched to the nearest " character

HOW TO READ THE OUTPUT (parser.txt)
The operator and operands will be visible in postfix notation. 
The statements in the body themselves will be in order. The individual statements can be read bottom-up from token to expression. 

WHILE LOOP
The statements of the while loop will be visible in order, starting from "WHILE-CONDITION"
The body of the while loop ends when "WHILE-LOOP" is visible in Parser.txt.
In case of nested while loops, the inner-most WHILE-CONDITION matches the nearest WHILE-LOOP and moves outwards. 

IF-ELSE STATEMENT
The if block begins with "IF-EXPRESSION" and ends with the "IF-STATEMENT"
The else block begins with "IF-BODY" and ends with "ELSE-BODY"
Read the statements in both blocks from top to bottom

FUNCTION-DECLARATION
The statements of the function declaration will all end with FUNC-ARG
The end of the function declaration will contain "FUNCTION-DECLARATION" followed by the name of the function.

FUNCTION-DEFINITION
The end of the function definition will be denoted by "FUNCTION-BODY" followed by the name of the function.
The beginning of the function may be one of three ways. It may be from the end of another function to the end of the current function
It may be from a global-variable to the end of the current function
It may be from FUNCTION-DECLARATION to the end of the current function.
Read the statements in the function body from top to bottom. 

FUNCTION-CALL
Similar to a function declaration. 
All of the arguements will end with the arguement FUNC-ARG
The end will be contain "FUNCTION-CALL" followed by the name of the function that is being called. 

