# import args.args 
import sys

emperorVersion:str = '0.1.0'

################################################################################
import argparse
from datetime import date
import inspect
import os.path
import textwrap

STDIN_FLAG = '-'

class TroffArgumentParser(argparse.ArgumentParser):
	def __init__(self, *args, **kwargs):
		super(TroffArgumentParser, self).__init__(*args, **kwargs)
		if 'date' in kwargs:
			self.date = kwargs['date']
		else:
			self.date = date.today().strftime('%d %B %Y')

	def toTroff(self) -> str:
		# print(inspect.getmembers(self))
		# print('===')
		# print(self.__dict__)
		# print('===')
		options:[argparse.Action] = self._actions
		options.sort(key=lambda option : self._checkMandatory(option))
		# print(self.__dict__['prog'])
		# print(self.__dict__['description'])
		# print(self.__dict__['prefix_chars'])
		# print('===')
		# for optionKey in options:
		# 	option:argparse._HelpAction = options[optionKey]
		# 	print(f'\t{option.option_strings}\t{option.nargs}\t{option.choices}\t{option.dest}\t{option.metavar}\n\t\t{option.help}')
		
		troffOutput:str = f'.TH {self.prog} 1 "{self.date}"\n'
		troffOutput += self._name(self.prog, self.description)
		troffOutput += self._synopsis(self.prog, options)
		troffOutput += self._description(self.description)
		troffOutput += self._options(options)
		return troffOutput

	def _checkMandatory(self, action:argparse.Action) -> bool:
		return True if action.option_strings == [] else False

	def _name(self, prog:str, description:str) -> str:
		return f'.SH "NAME"\n\\fB{prog}\\fP - {description}\n'

	def _synopsis(self, prog:str, options:[argparse.Action]) -> str:
		return f'.SH "SYNOPSIS"\n\\fB{prog}\\fP [OPTION]... [file... | -]\n'

	def _description(self, description:str) -> str:
		if description != '':
			return f'.SH "DESCRIPTION"\n{description}\n'
		else:
			return ''

	def _options(self, options:[argparse.Action]) -> str:
		description:str = f'.SH "OPTIONS"'
		firstOption:bool = True
		previousWasMandatory:bool = False
		mandatory:bool = False
		for option in options:
			mandatory = self._checkMandatory(option)
			if firstOption:
				if mandatory:
					description += f'\n.SS "Mandatory arguments"'
				else:
					description += f'\n.SS "Optional arguments"'
			elif mandatory and not previousWasMandatory:
				description += f'\n.SS "Mandatory arguments"'
				doingMandatory = True
			# 	switchToPrintingMandatoryOptions = False
			# if not self._checkMandatory(option):
			# 	switchToPrintingMandatoryOptions = True
			optionString:str = self._formatList(option.option_strings) if option.option_strings != [] else option.metavar
			optionString = r'\fB' + optionString + r'\fP '
			if option.choices is not None:
				choices:str = self._formatList(option.choices)
				optionString += r'\fI{' + choices + r'}\fP'
			optionDescription:str = f'\n.TP\n{optionString}\n{option.help}'
			description += optionDescription
			firstOption = False
			previousWasMandatory = self._checkMandatory(option)
		return description

	def _formatList(self, lst:[str]) -> str:
		formattedList:str = ''
		if lst is not None:
			formattedList = ''
			firstItem:bool = True
			for item in lst:
				if not firstItem:
					formattedList += ', '
				firstItem = False
				formattedList += item
		return formattedList


def parseArguments(args:[str]) -> argparse.Namespace:
	parser:TroffArgumentParser = TroffArgumentParser(
		# prog = 'emperor',
		description = f'''This is the compiler for the Emperor language v{emperorVersion}''',
		epilog = '''This is maintained by Edward Jones, and source code can be found at https://github.com/TheSignPainter98/emperor'''
	)	
	parser.add_argument('-v', '--verbose', action='store_true', help='Output verbosity')
	parser.add_argument('files', metavar='file', type=str, nargs='*', help='A file to compile')
	parser.add_argument('-O', '--optimisation', choices=[ 's', '0', '1', '2' ], default=0, dest='optimisation', help='Compiler optimisation level (see gcc)')
	parser.add_argument('-c', '--to-c', action='store_true', dest='compileCOnly', help='Translate to C (skips compilation step)')
	parser.add_argument('-o', '--output', type=str, dest='outputFile', default=None, help='Specify output file')

	print(parser.toTroff())
	
	return _validateArgs(parser.parse_args(args))

def _unique(inputList:[str], key=lambda x : x) -> [str]:
	uniqueList:[str] = []
	uniqueListKeys:[] = []

	for item in inputList:
		itemKey = key(item)
		if itemKey not in uniqueListKeys:
			uniqueListKeys.append(itemKey)
			uniqueList.append(item)

	return uniqueList

def _sanitiseFilePath(filePath:str) -> str:
	if filePath != STDIN_FLAG:
		return os.path.abspath(filePath)
	else:
		return filePath

def _validateArgs(arguments:argparse.Namespace) -> argparse.Namespace:
	if arguments.files == []:
		arguments.files = [STDIN_FLAG]
	else:
		arguments.files = list(map(_sanitiseFilePath, arguments.files))

	# arguments.files = list(map(sanitiseFilePath, arguments.Files))

	# arguments.files = unique(arguments.files)

	# if arguments.outputFile is None:
	# 	if len(arguments.files) == 1:
	# 		if arguments.files == STDIN_FLAG:
	# 			arguments.outputFile = 'emperorOut.o'
	# 		else:
	# 			arguments.outputFile = os.path.split(arguments.files[0])[0] + '.o'
	# outputParts:str*str = os.path.split(arguments.files[0])
	# outputFile = outputParts[1].split('.')[0] + '.o'
	# arguments.outputFile = outputParts + '/' + outputFile


	return arguments

################################################################################

# cdef extern from "./parser/emperor.tab.h":
# 	int parseStd()
	
def main(args:[str]) -> int:
	arguments:argparse.NameSpace = parseArguments(args)
	# print('Argument is verbose <==> %s' %('true' if arguments.verbose else 'false'))

	# print('Hello, world! This is Cython!')

	# print(f'This will be running on input files: {arguments.files}')
	# print(f'Running at optimisation level: {arguments.optimisation}')
	# print(f'Compiling to C only?: {arguments.compileCOnly}')
	# print(f'Output will be written in \"{arguments.outputFile}\"')

if __name__ == '__main__':
	main(sys.argv[1:])
