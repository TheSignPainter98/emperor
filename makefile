#!/usr/bin/make

.PHONY: all src clean test
all: src

src:
	+$(MAKE) -C src

clean:
	+$(MAKE) -C src clean

test:
	+$(MAKE) -C test test