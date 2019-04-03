# import args.args 
import sys

emperorVersion:str = '0.1.0'
emperorVersionString:str = 'emperor 0.1.0\nWritten by Edward Jones\n\nCopyright (C) 2015 Edward Jones\nThis is free software; see the source for copying conditions.  There is NO\nwarranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'

################################################################################
import argparse
from datetime import date
import inspect
import os.path
import textwrap

STDIN_FLAG = '-'

class TroffArgumentParser(argparse.ArgumentParser):
	def __init__(self, licence:str=None, seeAlso:str=None, date:str=date.today().strftime('%d %B %Y'), bugs:str=None, *args, **kwargs):
		super(TroffArgumentParser, self).__init__(*args, **kwargs)
		self.licence = licence
		self.date = date
		self.seeAlso = seeAlso
		self.bugs = bugs

	def toTroff(self) -> str:
		options:[argparse.Action] = self._actions
		options.sort(key=lambda option : self._checkMandatory(option))

		troffOutput:str = self._header(self.prog, self.date, self.licence)
		troffOutput += self._name(self.prog, self.description)
		troffOutput += self._synopsis(self.prog, options)
		troffOutput += self._description(self.description)
		troffOutput += self._options(options)
		troffOutput += self._seeAlso(self.seeAlso)
		troffOutput += self._bugs(self.bugs)
		troffOutput += self._authors(self.epilog)
		return troffOutput

	def _checkMandatory(self, action:argparse.Action) -> bool:
		return True if action.option_strings == [] else False

	def _header(self, program:str, date:str, licence:str) -> str:
		return f'{licence}\n.TH {self.prog.upper()} 1 "{self.date}"\n'

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
				choices:str = self._formatList(option.choices, separator=',')
				optionString += r'\fI{' + choices + r'}\fP'
			elif option.nargs is None:
				optionString += r'\fI' + (option.metavar.upper() if option.metavar is not None else option.dest.upper()) + r'\fP'
				pass
			elif option.nargs == '*':
				pass
			elif option.nargs == '+':
				pass
			elif int(option.nargs) >= 0:
				pass

			optionDescription:str = f'\n.TP\n{optionString}\n{option.help}'
			description += optionDescription
			firstOption = False
			previousWasMandatory = self._checkMandatory(option)
		return description + '\n'

	def _formatList(self, lst:[str], separator:str=', ') -> str:
		formattedList:str = ''
		if lst is not None:
			formattedList = ''
			firstItem:bool = True
			for item in lst:
				if not firstItem:
					formattedList += separator
				firstItem = False
				formattedList += item
		return formattedList

	def _seeAlso(self, seeAlso:str) -> str:
		return f'.SH "SEE ALSO"\n{seeAlso}\n' if seeAlso is not None else ''

	def _bugs(self, bugs:str) -> str:
		return f'.SH "BUGS"\n{bugs}\n' if bugs is not None else ''

	def _authors(self, epilog:str) -> str:
		return f'.SH "AUTHOR"\n{epilog}\n' if epilog is not None else ''


def parseArguments(args:[str]) -> argparse.Namespace:
	parser:TroffArgumentParser = TroffArgumentParser(
		licence=(
			'.\\" Copyright (c) <year>, <copyright holder>\n'
			'.\\"\n'
			'.\\" %%%LICENSE_START(GPLv2+_DOC_FULL)\n'
			'.\\" This is free documentation; you can redistribute it and/or\n'
			'.\\" modify it under the terms of the GNU General Public License as\n'
			'.\\" published by the Free Software Foundation; either version 2 of\n'
			'.\\" the License, or (at your option) any later version.\n'
			'.\\"\n'
			'.\\" The GNU General Public License\'s references to "object code"\n'
			'.\\" and "executables" are to be interpreted as the output of any\n'
			'.\\" document formatting or typesetting system, including\n'
			'.\\" intermediate and printed output.\n'
			'.\\"\n'
			'.\\" This manual is distributed in the hope that it will be useful,\n'
			'.\\" but WITHOUT ANY WARRANTY; without even the implied warranty of\n'
			'.\\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n'
			'.\\" GNU General Public License for more details.\n'
			'.\\"\n'
			'.\\" You should have received a copy of the GNU General Public\n'
			'.\\" License along with this manual; if not, see\n'
			'.\\" <http://www.gnu.org/licenses/>.\n'
			'.\\" %%%LICENSE_END'
		),
		description = f'''Compiler for the Emperor language v{emperorVersion}''',
		seeAlso = r'''\fBgcc\fR(1), \fBdux\fP(1), \fBbison\fP(1), \fBflex\fP(1)''',
		bugs = f'''There are no known bugs at this time! :D If you find any, however, please report them at <https://github.com/TheSignPainter98/emperor/issues>''',
		epilog = '''This is maintained by Edward Jones, and source code can be found at <https://github.com/TheSignPainter98/emperor>'''
	)	
	parser.add_argument('-v', '--verbose', action='store_true', help='Output verbosity')
	parser.add_argument('-V', '--version', action='store_true', help='Output version and exit')
	parser.add_argument('-m', '--man_page', dest='output_man', action='store_true', help='Output man page formatted in Troff and exit')
	parser.add_argument('-O', '--optimisation', choices=[ 's', '0', '1', '2' ], default=0, dest='optimisation', help='Compiler optimisation level (see gcc)')
	parser.add_argument('-c', '--to-c', action='store_true', dest='compileCOnly', help='Translate to C (skips compilation step)')
	parser.add_argument('-o', '--output', type=str, dest='outputFile', metavar='OUTPUT_FILE', default=None, action='store', help='Specify output file')
	parser.add_argument('files', metavar='file', type=str, nargs='*', help='A file to compile')
	
	return _validateArgs(parser, parser.parse_args(args))

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

def _validateArgs(parser:TroffArgumentParser, arguments:argparse.Namespace) -> argparse.Namespace:
	if arguments.version:
		print(emperorVersionString)
		sys.exit(0)

	if arguments.output_man:
		print(parser.toTroff(), end='')
		sys.exit(0)

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
	print('Argument is verbose <==> %s' %('true' if arguments.verbose else 'false'))

	print('Hello, world! This is Cython!')

	print(f'This will be running on input files: {arguments.files}')
	print(f'Running at optimisation level: {arguments.optimisation}')
	print(f'Compiling to C only?: {arguments.compileCOnly}')
	print(f'Output will be written in \"{arguments.outputFile}\"')

if __name__ == '__main__':
	main(sys.argv[1:])
