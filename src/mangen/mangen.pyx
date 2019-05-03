import argparse
from datetime import date
import json
import sys
import os.path
import argparse

class TroffArgumentParser(object):
	def __init__(self, json:dict=None, licence:[str]=[], version:str=None, seeAlso:[str]=[], date:str=date.today().strftime('%d %B %Y'), bugs:str=None, *args, **kwargs):
		super(TroffArgumentParser, self).__init__(*args, **kwargs)
		self.prog = json['prog'] if json is not None and 'prog' in json else sys.args[0]
		self.description = json['description'] if json is not None and 'description' in json else '' 
		self.licence = json['licence'] if json is not None and 'licence' in json else licence
		self.version = json['version'] if json is not None and 'version' in json else version
		self.date = json['date'] if json is not None and 'date' in json else date
		self.seeAlso = json['seeAlso'] if json is not None and 'seeAlso' in json else seeAlso
		self.bugs = json['bugs'] if json is not None and 'bugs' in json else bugs
		self._actions:[argparse.Action] = json['actions'] if json is not None and 'actions' in json else []
		self.epilog = json['epilog'] if json is not None and 'epilog' in json else ''

	def toTroff(self) -> str:
		options:[argparse.Action] = self._actions
		options.sort(key=lambda option : option['required'])

		troffOutput:str = self._header(self.prog, self.date, self.version, self.licence)
		troffOutput += self._name(self.prog, self.description)
		troffOutput += self._synopsis(self.prog, options)
		troffOutput += self._description(self.description)
		troffOutput += self._options(options)
		troffOutput += self._seeAlso(self.seeAlso)
		troffOutput += self._bugs(self.bugs)
		troffOutput += self._authors(self.epilog)
		return troffOutput

	def _header(self, program:str, date:str, version:str, licence:[str]) -> str:
		licenceString:str = ''.join(list(map(lambda line: r'.\" ' + line, licence)))
		return f'{licenceString}\n.TH {program.upper()} 1 "{date}" "{program} {version}" "User Commands" "fdsa"\n'

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
			mandatory = option['required']
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
			optionString:str = self._formatList(option['option_strings']) if option['option_strings'] != [] else option['metavar']
			optionString = r'\fB' + optionString + r'\fP '
			if option['choices'] is not None:
				choices:str = self._formatList(option['choices'], separator=',')
				optionString += r'\fI{' + choices + r'}\fP'
			elif option['nargs'] is None:
				optionString += r'\fI' + (option['metavar'].upper() if option['metavar'] is not None else option['dest'].upper()) + r'\fP'
				pass
			elif option['nargs'] == '*':
				pass
			elif option['nargs'] == '+':
				pass
			elif int(option['nargs']) >= 0:
				pass

			optionHelp:str = option['help']
			optionDescription:str = f'\n.TP\n{optionString}\n{optionHelp}'
			description += optionDescription
			firstOption = False
			previousWasMandatory = option['required']
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

	def _seeAlso(self, seeAlso:[str]) -> str:
		if seeAlso == []:
			return ''
		else:
			seeAlsos:str = ', '.join(seeAlso)
			return f'.SH "SEE ALSO"\n{seeAlsos}\n'

	def _bugs(self, bugs:str) -> str:
		return f'.SH "BUGS"\n{bugs}\n' if bugs is not None else ''

	def _authors(self, epilog:str) -> str:
		return f'.SH "AUTHOR"\n{epilog}\n' if epilog is not None else ''


def printe(*args, **kwargs):
	print(*args, file=sys.stderr, **kwargs)


def main(args:[str]) -> int:
	if not all(list(map(lambda arg: arg.endswith('.json'), args))):
		printe('Inputs must have the ".json" extension')
		badFiles:[str] = list(filter(lambda f: os.path.isfile(f), args))
		for badFile in badFiles:
			printe(f'File "{badFile}" does not exist')
		return 126

	if not all(list(map(lambda arg: os.path.isfile(arg), args))):
		printe('Input files must exist')
		badFiles:[str] = list(filter(lambda f: os.path.isfile(f), args))
		for badFile in badFiles:
			printe(f'File "{badFile}" does not exist')
		return 126

	troffArgumentParser:TroffArgumentParser = TroffArgumentParser(json=json.loads(input()))
	print(troffArgumentParser.toTroff(), end='')

	return 0

if __name__ == '__main__':
	sys.exit(main(sys.argv[1:]))