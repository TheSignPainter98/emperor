#!/bin/bash

cd ../src/emperor/parser/ &&
(
	bison -v -d emperor.yacc &&
	flex emperor.lex &&
	mv emperor.tab.cacc emperor.tab.c && 
	gcc emperor.tab.c lex.yy.c # echo --- && rlwrap ./a.out
 ) &&
# (
# 	yacc -v -d emperor.yacc && 
# 	lex emperor.lex && 
# 	cc y.tab.c lex.yy.c -Wimplicit-function-declaration
# ) && # echo --- && rlwrap ./a.out
cd ../../../scripts/ &&
python3 make.py build_ext --inplace --quiet

