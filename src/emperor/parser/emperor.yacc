%{
	#include <stdio.h>
	int currentLine = 1;
	int currentChar = 1;
	int yylex(void);
%}
%start typein
%token RADIX_POINT
%token OPEN_PARENTH
%token CLOSE_PARENTH
%token OPEN_TYPE_ANNOT
%token CLOSE_TYPE_ANNOT
%token LIST_SEPARATOR
%token DEFAULT_EQUALS
%token RETURNS
%token OPERATOR
%token DIGIT 
%token LETTER
%token ACCESS_MODIFIER
%token PURITY_PURE
%token PURITY_IMPURE
%token NAME
%token PRIMITIVE_TYPE
%token BOOLEAN
%token LONG_TAIL
%token HEX_VALUE
%token BITSEQUENCE_VALUE

%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMINUS	/*supplies precedence for unary minus */
%%									 /* beginning of rules section */
typein: HEX_VALUE '\n';
primitive_constant: number | real | BOOLEAN | long | HEX_VALUE | BITSEQUENCE_VALUE;
value: NAME | primitive_constant;
valuelist: value | value LIST_SEPARATOR valuelist;
maybevaluelist: | valuelist;
expression: value | expression OPERATOR expression;
functioncall: NAME OPEN_PARENTH maybevaluelist CLOSE_PARENTH 
{
	printf("Function call: %d with arguments %d\n", $1, $2);
};
natural: DIGIT | DIGIT natural;
number:	UMINUS natural | natural;
real:	number RADIX_POINT number;
long:	number LONG_TAIL;
defaultvalue: | DEFAULT_EQUALS expression;
parameterList:	type NAME defaultvalue;
type: 	PRIMITIVE_TYPE | NAME | NAME OPEN_TYPE_ANNOT typeList CLOSE_TYPE_ANNOT;
typeList:	type | type LIST_SEPARATOR typeList;
functionSignature: pureFunction | impureFunction;
pureFunction:	ACCESS_MODIFIER PURITY_PURE NAME OPEN_PARENTH typeList CLOSE_PARENTH RETURNS type;
impureFunction:	ACCESS_MODIFIER PURITY_IMPURE NAME OPEN_PARENTH typeList CLOSE_PARENTH impureReturnAnnotation;
impureReturnAnnotation: | RETURNS type;

%%

int main(void)
{
	return(yyparse());
}

void yyerror(s)
char *s;
{
	fprintf(stderr, "%s\n",s);
}

int yywrap(void)
{
	return(1);
}