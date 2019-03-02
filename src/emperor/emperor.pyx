
# cimport actions.actions
import parser 

cdef extern from "./actions/actions.c":
	void action()

def main(args:list) -> int:
	print('Hello, world!')
	return 0

