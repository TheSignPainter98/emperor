#!/usr/bin/make

.PHONY: all emperor emperordoc emperorlint mangen clean

all: emperor emperordoc emperorlint;

emperor: mangen
	+$(MAKE) -C emperor

emperordoc:
	+$(MAKE) -C emperordoc

emperorlint:
	+$(MAKE) -C emperorlint

mangen:
	+$(MAKE) -C mangen

clean:
	+$(MAKE) -C emperor clean
	+$(MAKE) -C emperordoc clean
	+$(MAKE) -C emperorlint clean
	+$(MAKE) -C mangen clean