use the following commands to execute

yacc -d parser.y
lex lexer.l
gcc y.tab.c lex.yy.c -ll -ly
./a.out <file.text
