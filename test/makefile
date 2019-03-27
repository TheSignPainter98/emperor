#!/usr/bin/make

.PHONY: all test

all: test ;

test: emperor
	-@ ln -s ../src/emperor/emperor ./emperor 2>/dev/null || true
	./run_tests.sh

emperor:
	$(MAKE) -C .. emperor
