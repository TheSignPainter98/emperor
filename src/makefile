#!/usr/bin/make

.PHONY: all emperor emperordoc emperorlint clean

all: emperor emperordoc emperorlint;

emperor: 
	+$(MAKE) -C emperor

emperordoc:
	+$(MAKE) -C emperordoc

emperorlint:
	+$(MAKE) -C emperorlint

clean:
	+$(MAKE) -C emperor clean
	+$(MAKE) -C emperordoc clean
	+$(MAKE) -C emperorlint clean