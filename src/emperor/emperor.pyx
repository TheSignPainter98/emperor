
# cimport actions.actions
import argparse
import parser 

cdef extern from "./actions/actions.c":
	void action()

def main(args:list) -> int:
	print('Hello, world!')
	action()
	print('Make some input pls!> ')
	string = input()
	print(f'You inputted: {string}')
	return 0

