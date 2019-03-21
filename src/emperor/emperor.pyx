
# cimport actions.actions
import argparse
import parser 

cdef extern from "./parser/emperor.tab.c":
	int parseFiles(char** files)
	int parseFile(char* file)

def main(args:[str]) -> int:
	parseFiles(args)

if __name__ == '__main__':
	main(['-'])

