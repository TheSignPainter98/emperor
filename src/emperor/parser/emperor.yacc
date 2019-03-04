%{
	#include <stdio.h>
	int currentLine = 1;
	int currentChar = 1;
	int yylex(void);
	void yyerror(char* s);

	extern struct yy_buffer_state* yy_scan_string(char * str);
	extern void yy_delete_buffer(struct yy_buffer_state* buffer);
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
%token NUMBER 
%token REAL 
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
typein: NUMBER;
// primitive_constant: NUMBER | REAL | BOOLEAN | long | HEX_VALUE | BITSEQUENCE_VALUE;
// value: primitive_constant | NAME;
// long:	NUMBER LONG_TAIL;
// valuelist: value | value LIST_SEPARATOR valuelist;
// maybevaluelist: | valuelist;
// expression: value | expression OPERATOR expression;
// functioncall: NAME OPEN_PARENTH maybevaluelist CLOSE_PARENTH 
// {
// 	// printf("Function call: %d with arguments %d\n", $1, $2);
// };
// defaultvalue: | DEFAULT_EQUALS expression;
// parameterList:	type NAME defaultvalue;
// type: 	PRIMITIVE_TYPE | NAME | NAME OPEN_TYPE_ANNOT typeList CLOSE_TYPE_ANNOT;
// typeList:	type | type LIST_SEPARATOR typeList;
// functionSignature: pureFunction | impureFunction;
// pureFunction:	ACCESS_MODIFIER PURITY_PURE NAME OPEN_PARENTH typeList CLOSE_PARENTH RETURNS type;
// impureFunction:	ACCESS_MODIFIER PURITY_IMPURE NAME OPEN_PARENTH typeList CLOSE_PARENTH impureReturnAnnotation;
// impureReturnAnnotation: | RETURNS type;

%%

int main(void)
{
	char* inputString = "0x143298";
	printf("Running on string: '%s'\n", inputString);
	struct yy_buffer_state* buffer = yy_scan_string(inputString);
	int retval = yyparse();
	yy_delete_buffer(buffer);
	return retval;
	// printf("%s", "Type string for input > ");
	// return yyparse();
}

void yyerror(char* s)
{
	fprintf(stderr, "%s\n",s);
}

int yywrap(void)
{
	return 1;
}