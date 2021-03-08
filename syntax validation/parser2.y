%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE char*
int yyerror(char* s);
int yylex();
%}
%token ID NUM LE GE EQ NE OR AND DO WHILE INT PGRM FOR T_BEGIN END ENDDOT VAR TO PRGM SEMICOLON COLON COMMA AO
%right '='
%left AND OR
%left '<' '>' LE GE EQ NE
%left '+''-'
%left '*''/'
%right UMINUS
%left '!'
%%

start : PGRM ID SEMICOLON T_BEGIN STATE ENDDOT;


STATE : |T_BEGIN STATE END
        |VAR X
	|Exp SEMICOLON STATE
        |FOR TO NUM DO T_BEGIN STATE END SEMICOLON STATE
        |WHILE Exp DO STATE 
	;
        

X:    |Exp ':' INT SEMICOLON STATE
      |Exp','X
      |SEMICOLON STATE
      ;
	

Exp   : ID AO Exp
      | Exp'='Exp
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


%%

int yywrap(){
 return 1;}
int yyerror(char* s){
printf("%s \n", s);
}
int main()
{	
   if(!yyparse()){
		printf("\nParsing complete, no syntax error\n");}
	else{

		printf("\nParsing failed\n");}

    return 0;
}
