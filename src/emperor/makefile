CC = gcc-8
CFLAGS := $(CFLAGS) -Wall -Os -I . -I /usr/include/python3.6m
CP = cp
OUTPUT_FILE := ./emperor
MAKEFLAGS := $(MAKEFLAGS) s

.PHONY: all clean actions parser run

all: $(OUTPUT_FILE) ;

$(OUTPUT_FILE): ./parser/parser.so ./actions/actions.o ./emperor.c
	$(CC) $(CFLAGS) ./emperor.c ./parser/parser.so ./actions/actions.o -lpython3.6m -o $(OUTPUT_FILE)

./%.o: ./%.c ./%.h

./actions/%.o:
	@$(MAKE) actions

./parser/parser.so:
	@$(MAKE) parser

./emperor.c: ./emperor.pyx
	cython --embed --directive language_level=3 ./emperor.pyx

actions:
	@$(MAKE) -C actions

parser:
	@$(MAKE) -C parser

./emperor.pyx: ;

clean:
	+@$(MAKE) -C actions $@
	+@$(MAKE) -C parser $@
	-@$(RM) *.o					2>/dev/null	|| true
	-@$(RM) *.so				2>/dev/null	|| true
	-@$(RM) emperor.c			2>/dev/null	|| true
	-@$(RM) Python.h			2>/dev/null	|| true
	-@$(RM) $(OUTPUT_FILE)		2>/dev/null	|| true
	-@$(RM) -R build			2>/dev/null	|| true
	
# THE FOLLOWING SEEMS TO WORK!
# cython --embed ./emperor.pyx
# gcc-8 -Os -I /usr/include/python3.6m ./emperor.c -lpython3.6m -o ./emperor