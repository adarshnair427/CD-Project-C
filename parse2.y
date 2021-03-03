%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE char*
int yylex();
void yyerror(char* s);
%}
%token ID NUM LE GE EQ NE OR AND DO WHILE COLON INT PGRM FOR T_BEGIN END ENDDOT VAR TO  SEMICOLON COMMA AO
%right '='
%left AND OR
%left '<' '>' LE GE EQ NE
%left '+''-'
%left '*''/'
%left '!'
%right UMINUS
%%

start : BODY
	;

BODY :  |T_BEGIN BODY ENDDOT
	|T_BEGIN BODY END
	|T_BEGIN BODY END SEMICOLON
	|WHILE Exp DO BODY
        |Exp SEMICOLON BODY      
	|VAR BODY
        |FOR Exp TO Exp DO T_BEGIN BODY END SEMICOLON BODY
	;      

X     :|COLON INT SEMICOLON
       |COMMA Exp X
       |SEMICOLON BODY
       ;

Exp  : ID AO Exp
      |Exp COMMA Exp
      |ID COMMA Exp
      | Exp'+'Exp
      | Exp'-'Exp
      | Exp'*'Exp
      | Exp'/'Exp
      | Exp'<'Exp
      | Exp'>'Exp
      | Exp LE Exp
      | Exp GE Exp
      | Exp EQ Exp
      | Exp NE Exp
      | Exp OR Exp
      | Exp AND Exp
      | NUM
      | X
      | ID
      ;


%%
void yyerror(char* s){
printf("%s \n", s);
}
int main()
{
	
if(!yyparse()){
		printf("\nParsing complete\n");}
	else{
		printf("\nParsing failed\n");}
return 0;
}
  
