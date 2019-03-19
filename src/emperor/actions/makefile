#!/usr/bin/make
CC = gcc

.PHONY: all;

all: actions.o;

actions.o: actions.c;

actions.c:
	$(CC) -c actions.c -o actions.o

clean:
	-@ rm *.o		2>/dev/null	|| true
