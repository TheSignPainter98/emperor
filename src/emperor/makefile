CC = gcc
OUTPUT_FILE := ./emperor.exe
MAKEFLAGS := $(MAKEFLAGS) s

.PHONY: all clean actions parser run

all: $(OUTPUT_FILE) ;
$(OUTPUT_FILE): ./parser/%.o ./actions/%.o
	$(CC) -o $(OUTPUT_FILE) ./actions/actions.o ./parser/emperor.yy.o ./parser/emperor.tab.o
	python3 ./make.py build_ext --inplace --quiet 

./%.o: ./%.c ./%.h

./actions/%.o:
	@$(MAKE) actions

./parser/%.o:
	@$(MAKE) parser

actions:
	@$(MAKE) -C actions

parser:
	@$(MAKE) -C parser

clean:
	+@$(MAKE) -C actions $@
	+@$(MAKE) -C parser $@
	-@ $(RM) *.o				2>/dev/null	|| true
	-@ $(RM) emperor.c			2>/dev/null	|| true
	-@ $(RM) $(OUTPUT_FILE)		2>/dev/null	|| true
	-@ $(RM) -R build			2>/dev/null	|| true
	