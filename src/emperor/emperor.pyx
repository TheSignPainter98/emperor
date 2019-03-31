import argparse
import sys
import os.path

emperorVersion:str = '0.1.0'
STDIN_FLAG = '-'

cdef extern from "./parser/emperor.tab.h":
	int parseStd()
	
def _parseArguments(args:[str]) -> argparse.Namespace:
	parser:argparse.ArgumentParser = argparse.ArgumentParser(
		prog = 'emperor',
		description = f'''This is the compiler for the Emperor language 
			v{emperorVersion}''',
		epilog = '''This is maintained by Edward Jones, and source code can be 
			found at https://github.com/TheSignPainter98/emperor'''
	)
	parser.add_argument('-v', '--verbose', action='store_true', help='Output verbosity')
	parser.add_argument('files', metavar='file', type=str, nargs='*', help='A file to compile')
	parser.add_argument('-O', '--optimisation', choices=[ 's', '0', '1', '2' ], default=0, dest='optimisation', help='Compiler optimisation level (see gcc)')
	parser.add_argument('-c', '--to-c', action='store_true', dest='compile', help='Translate to C (skips compilation step)')
	parser.add_argument('-o', '--output', type=str, dest='outputFile', default=None, help='Translate to C (skips compilation step)')

	return validateArgs(parser.parse_args(args))

def unique(inputList:[str]) -> [str]:
	uniqueList:[str] = []

	for item in inputList:
		sanitisedItem = sanitiseFilePath(item)
		if sanitisedItem not in uniqueList:
			uniqueList.append(sanitisedItem)

	return uniqueList

def sanitiseFilePath(filePath:str) -> str:
	if filePath != STDIN_FLAG:
		return os.path.abspath(filePath)
	else:
		return filePath

def validateArgs(arguments:argparse.Namespace) -> argparse.Namespace:

	arguments.files = unique(arguments.files)

	return arguments

def main(args:[str]) -> int:
	arguments:argparse.Namespace = _parseArguments(args)
	print('Argument is verbose <==> %s' %('true' if arguments.verbose else 'false'))

	print('Hello, world! This is Cython!')

	if arguments.files == []:
		arguments.files = [STDIN_FLAG]

	print(f'This will be running on input files: {arguments.files}')
	print(f'Running at optimisation level: {arguments.optimisation}')
	print(f'Compiling to C only?: {arguments.compileCOnly')
	print(f'Output will be written in {arguments.outputFile}'')

if __name__ == '__main__':
	main(sys.argv[1:])
