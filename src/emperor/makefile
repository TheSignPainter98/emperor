CC = gcc

.PHONY: all actions parser clean

all: emperor actions parser
	# $(CC) -c ./emperor.c
	# $(CC) -o ./emperor.exe ./emperor.o ./actions/actions.o ./parser/emperor.yy.o ./parser/emperor.tab.o
	$(CC) -o ./emperor.exe ./actions/actions.o ./parser/emperor.yy.o ./parser/emperor.tab.o

emperor: ;
	# python3 ./make.py build_ext --inplace --quiet

actions:
	+$(MAKE) -C actions

parser:
	+$(MAKE) -C parser

clean:
	+$(MAKE) -C actions $@
	+$(MAKE) -C parser $@
	-@ rm *.o				2>/dev/null	|| true
	-@ rm ./emperor.exe		2>/dev/null	|| true
	