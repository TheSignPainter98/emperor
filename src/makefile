#!/usr/bin/make

.PHONY: all emperor emperor-lib emperor-langemperordoc emperorlint clean

all: emperor emperor-lib emperor-lang emperordoc emperorlint;

emperor: 
	+$(MAKE) -C emperor

emperor-lib:
	+$(MAKE) -C emperor-lib

emperor-lang:
	+$(MAKE) -C emperor-lang

emperordoc:
	+$(MAKE) -C emperordoc

emperorlint:
	+$(MAKE) -C emperorlint

clean:
	+$(MAKE) -C emperor clean
	+$(MAKE) -C emperordoc clean
	+$(MAKE) -C emperor-lib clean
	+$(MAKE) -C emperor-lang clean
	+$(MAKE) -C emperorlint clean