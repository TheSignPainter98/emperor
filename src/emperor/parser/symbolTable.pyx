#!/usr/bin/cython3

class ObjectType(Enum):
	FUNCTION = 0
	VARIABLE = 1
	OBJECT = 3
	PACKAGE = 4

class Scope(object):
	nextScope:int = 0

	@classmethod
	def getUniqueScopeId(cls) -> int:
		nextScope += 1
		return nextScope

	def __init__(self, scope:int=cls.getUniqueScopeId(), variables:[Symbol] = []):
		self.scopeId = scopeId
		self.variables:[Symbol] = variables

class Symbol(object):
	def __init__(self, name:str, type:ObjectType, scope:Scope):
		self.name = name
		self.type = type
		self.scope = scope

	@staticmethod
	def newSymbol(scope:Scope) -> None:

class SymbolTable(object):
	def __init__(self):
		self.table:[SymbolTableRecord] = []
