LEX = flex
YACC = bison
CC = gcc
CFLAGS = # -shared -fPIC

.PHONY: all clean;

all: parser.o;

parser.o: emperor.tab.c emperor.yy.c AST.c Primitives.c Keywords.c Symbols.c
	$(CC) $(CFLAGS) -o parser.o AST.c Primitives.c Keywords.c Symbols.c emperor.tab.c emperor.yy.c

emperor.yy.c: emperor.lex
	$(LEX) -o emperor.yy.c emperor.lex 

emperor.tab.c: emperor.yacc
	$(YACC) -v -d -o emperor.tab.c emperor.yacc 

emperor.lex:;
emperor.yacc:;
AST.c:;
Primitives.c:;
Symbols.c:;

clean:
	-@ rm *.o		2>/dev/null	|| true
	-@ rm *.yy.c	2>/dev/null	|| true
	-@ rm *.tab.*	2>/dev/null	|| true
	-@ rm *.output	2>/dev/null	|| true 
	
