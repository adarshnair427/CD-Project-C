use the following commands to execute

yacc -d parse.y

lex tok1.l

gcc y.tab.c lex.yy.c -ll -ly

./a.out <file.text
