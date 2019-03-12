LEX = flex
YACC = bison
CC = gcc

# .SILENT:

all: parser lexer
	$(CC) -c emperor.tab.c emperor.yy.c

lexer:
	$(LEX) -o emperor.yy.c emperor.lex 

parser:
	$(YACC) -v -d -o emperor.tab.c emperor.yacc 

clean:
	-@ rm *.o		2>/dev/null	|| true
	-@ rm *.yy.c	2>/dev/null	|| true
	-@ rm *.tab.*	2>/dev/null	|| true
	-@ rm *.output	2>/dev/null	|| true
	
