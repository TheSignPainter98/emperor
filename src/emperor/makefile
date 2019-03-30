CC = gcc-8
CFLAGS := $(CFLAGS) -Wall -Os
CP = cp
OUTPUT_FILE := ./emperor
MAKEFLAGS := $(MAKEFLAGS) s

.PHONY: all clean actions parser run

all: $(OUTPUT_FILE) ;

$(OUTPUT_FILE): ./parser/parser.o ./actions/actions.o ./emperor.c
	$(CC) $(CFLAGS) -Os -I /usr/include/python3.6m ./emperor.c ./actions/actions.o ./parser/parser.o -lpython3.6m  -o $(OUTPUT_FILE)

./%.o: ./%.c ./%.h

./actions/%.o:
	@$(MAKE) actions

./parser/parser.o:
	@$(MAKE) parser

./emperor.c:
	cython --embed --directive language_level=3 ./emperor.pyx

actions:
	@$(MAKE) -C actions

parser:
	@$(MAKE) -C parser

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