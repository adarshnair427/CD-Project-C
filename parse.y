%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE char*
int yylex();
%}

%token ID NUM LE GE EQ NE OR AND DO WHILE INT PGRM FOR BEGIN END ENDDOT VAR TO PRGM SEMICOLON COMMA AO
%right '='
%left AND OR
%left '<' '>' LE GE EQ NE
%left '+''-'
%left '*''/'
%left '!'
%right UMINUS
%%


start : PGRM ID SEMICOLON STATE;

STATE : |BEGIN
	|ENDOT
	|END
	|WHILE CH DO STATE
        |Exp SEMICOLON STATE
	|BEGIN STATE END SEMICOLON      
	|VAR Exp X
        |FOR Exp TO NUM DO BEGIN STATE END SEMICOLON STATE
	;
        


X     : COMMA X
       | SEMICOLON STATE
       ;

Exp   : ID AO Exp
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
      | ID
      ;

CH  : Exp'<'Exp
      | Exp'>'Exp
      | Exp LE Exp
      | Exp GE Exp
      | Exp EQ Exp
      | Exp NE Exp
      | Exp OR Exp
      | Exp AND Exp
      | ID
      | NUM
      ;


%%

#include "lex.yy.c"
int yywrap(){
 return 1;}
int main()
{
	
if(!yyparse()){
		printf("\nParsing complete\n");}
	else{
		printf("\nParsing failed\n");}
return 0;
}