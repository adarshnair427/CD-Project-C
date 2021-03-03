%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
void yyerror(char* s);
%}

alpha [A-Za-z]
digit [0-9]
%%
begin             return T_BEGIN;
end               return END;
"end."             {return ENDDOT;} //end.   
";"                return SEMICOLON;
":"                return COLON;
","	               return COMMA;
"to"               return TO;
"//".* ;           //comment section
"(*"(.|\n)*"*)"  ;  //MULTI LINE comment section
var   {return VAR;}//var
do    {return DO;} //do
integer	{return INT;}//int
while    {return WHILE;}//while
{digit}+    {return NUM;}//digit 
for       {return FOR;}//for
{alpha}({alpha}|{digit})*   { 
				yylval=strdup(yytext);
				return ID;}//Identifier
":="   {return AO;} //assignment operatorr				
"<="   {return LE;}//relational
">="   {return GE;}//relational
"="    {return EQ;}//relational
"<>"   {return NE;}//relational not equal
"|"    {return OR;}//relatinal
"&"    {return AND;}//relational
.       return yytext[0];
%%
