#!/usr/bin/make

all:

test: clean emperor
	ln -s ../../src/emperor/emperor.exe ./emperor.exe
	@ ./emperor.exe ./test.emp

emperor:
	+$(MAKE) -C ../.. all

clean:
	-@ rm *.exe				2>/dev/null	|| true
