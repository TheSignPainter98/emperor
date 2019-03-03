#!/bin/bash

cd ../src/emperor/parser/ &&
yacc -v -d emperor.yacc && lex emperor.lex && cc y.tab.c lex.yy.c -Wimplicit-function-declaration && # echo --- && rlwrap ./a.out
cd ../../../scripts/ &&
python3 make.py build_ext --inplace --quiet

