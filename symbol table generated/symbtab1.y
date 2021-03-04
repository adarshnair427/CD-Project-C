%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE char*
int yyerror(char* s);
int yylex();
int ok=1;
int scope=0;
int line=0;
int wh=0;
int* line_store;
char f[6]={'f','l','o','a','t','\0'};
char d[7]={'d','o','u','b','l','e','\0'};
char in[4]={'i','n','t','\0'};

typedef struct name{
int scope;
int *line;
int bytes;
char *type;
char *name;}identifier;


identifier *SYMBOL_TABLE;

int len=0;
int now=-1;
int c_r=0;

int check(identifier * SYMBOL_TABLE,int scope,int *line,int length,char *yylval,int which){
      for(int i=0;i<length;i++){
int a=0,b=0;
while(SYMBOL_TABLE[i].name[a]!='\0' && yylval[b]!='\0' && SYMBOL_TABLE[i].name[a]==yylval[b]){
a++;
b++;}

int c=1;
if(!(SYMBOL_TABLE[i].name[a]=='\0' && yylval[b]=='\0')){c=0;}
if(c && ((SYMBOL_TABLE[i].scope==scope && which==0)||(SYMBOL_TABLE[i].scope<=scope && which==1))){
int v=1;
for(int k=0;k<SYMBOL_TABLE[i].scope;k++){
if(!(SYMBOL_TABLE[i].line[k]==line[k])){
v=0;
break;
}
}
if(v==1){
      return 1;
}
}
}
return 0;

}


void insert(identifier *SYMBOL_TABLE ,int scope,int *line,int length,int t,char* yylval,int which){
      if(check(SYMBOL_TABLE,scope,line,len,yylval,which)){
            printf("Re-Declartion error\n");
            exit(0);
      }
int i;
for(i=0;yylval[i]!='\0';i++){
SYMBOL_TABLE[length].name[i]=yylval[i];
}
SYMBOL_TABLE[length].name[i]='\0';
SYMBOL_TABLE[length].scope=scope;
for(int j=0;j<scope;j++){
SYMBOL_TABLE[length].line[i]=line[i];
}
if(t==0){
      SYMBOL_TABLE[length].bytes=4;
      for(int i=0;i<=3;i++){
            SYMBOL_TABLE[length].type[i]=in[i];
      }



}
if(t==1){
      SYMBOL_TABLE[length].bytes=8;
      
      for(int i=0;i<=5;i++){
            SYMBOL_TABLE[length].type[i]=f[i];
      }

}
if(t==2){
      SYMBOL_TABLE[length].bytes=8;
      
      for(int i=0;i<=6;i++){
            SYMBOL_TABLE[length].type[i]=d[i];
      }

}
}



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


STATE : |WHILE Exp DO { line_store[scope]=line;scope++;line++; } STATE {scope--;line++;}STATE
        |Exp SEMICOLON STATE
	|T_BEGIN STATE END
        |VAR{c_r=1;} Exp{insert(SYMBOL_TABLE,scope,line_store,len,0,yylval,0);len++;now=0;} X
        |FOR {c_r=1;} Exp{insert(SYMBOL_TABLE,scope,line_store,len,0,yylval,0);len++;now=0;} TO NUM DO {line_store[scope]=line;scope++;line++;} T_BEGIN STATE END SEMICOLON {scope--;line++;}STATE;
        


X:COMMA{c_r=1;} Exp{insert(SYMBOL_TABLE,scope,line_store,len,now,yylval,0);len++;} X
      | SEMICOLON{c_r=0;} STATE
      |COLON Exp;
	;

Exp   : ID{if(c_r==0 && !check(SYMBOL_TABLE,scope,line_store,len,yylval,1)){printf("Identifier un-declared\n");exit(0);}c_r=0;} AO Exp
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
      | ID{if(c_r==0 && !check(SYMBOL_TABLE,scope,line_store,len,yylval,1)){printf("Identifier un-declared\n");exit(0);}}
      ;


%%

int yywrap(){
 return 1;}
int yyerror(char* s){
printf("%s \n", s);
}
int main()
{	
   line_store=malloc(sizeof(int)*100);
   SYMBOL_TABLE=malloc(sizeof(SYMBOL_TABLE)*100);
	for(int j=0;j<100;j++){
		SYMBOL_TABLE[j].scope=-1;
		SYMBOL_TABLE[j].line=malloc(sizeof(int)*100);
		SYMBOL_TABLE[j].name=malloc(sizeof(char)*100);
		SYMBOL_TABLE[j].type=malloc(sizeof(char)*100);
            SYMBOL_TABLE[j].bytes=0;
	}
int ok=1;
   if(!yyparse()){
		printf("\nParsing complete\n");}
	else{
	ok=0;
		printf("\nParsing failed\n");}
if(ok && len){
printf("SYMBOL TYPE BYTES\n");
for(int i=0;i<len;i++){
      printf("%s %s %d\n",SYMBOL_TABLE[i].name,SYMBOL_TABLE[i].type,SYMBOL_TABLE[i].bytes);
}
}
    return 0;
}
