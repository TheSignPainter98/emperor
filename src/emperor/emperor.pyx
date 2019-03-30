import argparse

cdef extern from "./parser/emperor.tab.h":
	int parseStd()
	
def parseArguments() -> argparse.Namespace:
	parser = argparse.ArgumentParser()
	parser.add_argument('-v', '--verbose', action='store_true', help='Output verbosity')
	return parser.parse_args()

def main(args:[str]) -> int:
	arguments = parseArguments()
	print('Argument is verbose <==> %s' %('true' if arguments.verbose else 'false'))

	print('Hello, world! This is Cython!')
	parseStd()
	# parseFiles(args)

if __name__ == '__main__':
	main(['-'])
