CC = gcc-8
CP = cp
OUTPUT_FILE := ./emperor
MAKEFLAGS := $(MAKEFLAGS) s

.PHONY: all clean actions parser run

all: $(OUTPUT_FILE) ;

$(OUTPUT_FILE): ./parser/parser.o ./actions/%.o # ./emperor.o
	$(CC) -I. -I/usr/include/python3.6m -o $(OUTPUT_FILE) ./actions/actions.o # ./parser/parser.o
	# $(CC) -shared -I. -I/usr/include/python3.6m -o $(OUTPUT_FILE) ./actions/actions.o ./parser/emperor.yy.o ./parser/emperor.tab.o

./%.o: ./%.c ./%.h

./actions/%.o:
	@$(MAKE) actions

./parser/parser.o:
	@$(MAKE) parser

./emperor.o: ./emperor.c
	# $(CC) -pthread -DNDEBUG -g -fwrapv -O2 -Wall -g -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -fPIC -I. -I/usr/include/python3.6m -c ./emperor.c -o ./emperor.o
	# $(CC) -pthread -shared -Wl,-O1 -Wl,-Bsymbolic-functions -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-Bsymbolic-functions -Wl,-z,relro -g -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 ./emperor.o -o emperor.cpython-36m-x86_64-linux-gnu.so
# 	$(CP) /usr/include/python3.6m/Python.h ./Python.h
# 	$(CP) /usr/include/python3.6m/patchlevel.h ./patchlevel.h
# 	$(CP) /usr/include/python3.6m/pyconfig.h ./pyconfig.h

./emperor.c:
	python3 ./make.py build_ext --inplace --quiet 

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
	