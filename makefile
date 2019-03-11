#!/usr/bin/make

all: src
.PHONY: all

src:
	+$(MAKE) -C src
.PHONY: src