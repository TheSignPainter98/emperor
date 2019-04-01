CC = gcc-8
CFLAGS := $(CFLAGS) -Wall -Os -I . -I /usr/include/python3.6m
CP = cp
OUTPUT_FILE := ./emperor
MAKEFLAGS := $(MAKEFLAGS) s

MAN_FILE := ./emperor.1

.PHONY: all clean actions parser run man

all: $(OUTPUT_FILE) ;

$(OUTPUT_FILE): ./parser/parser.so ./actions/actions.o ./emperor.c
	$(CC) $(CFLAGS) ./emperor.c ./parser/parser.so ./actions/actions.o -lpython3.6m -o $(OUTPUT_FILE)

./%.o: ./%.c ./%.h

./actions/%.o:
	@$(MAKE) actions

./parser/parser.so:
	@$(MAKE) parser

./emperor.c: ./emperor.pyx
	cython3 --embed --directive language_level=3 ./emperor.pyx

actions:
	@$(MAKE) -C actions

parser:
	@$(MAKE) -C parser

./emperor.pyx: ;

install: $(OUTPUT_FILE) $(MAN_FILE)
	echo "Installing! :D"

man: $(MAN_FILE)

$(MAN_FILE): $(OUTPUT_FILE)
	./emperor --help | groff -Tascii -man > $(MAN_FILE)

clean:
	+@$(MAKE) -C actions $@
	+@$(MAKE) -C parser $@
	-@$(RM) $(MAN_FILE)			2>/dev/null	|| true
	-@$(RM) *.o					2>/dev/null	|| true
	-@$(RM) *.so				2>/dev/null	|| true
	-@$(RM) emperor.c			2>/dev/null	|| true
	-@$(RM) Python.h			2>/dev/null	|| true
	-@$(RM) $(OUTPUT_FILE)		2>/dev/null	|| true
	-@$(RM) -R build			2>/dev/null	|| true
