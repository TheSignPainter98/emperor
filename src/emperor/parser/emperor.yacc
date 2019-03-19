%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <unistd.h>
	#define STDIN_FLAG "-"

	typedef void* yyscan_t;

	int currentLine = 1;
	int currentChar = 1;
	int main(int argc, char** argv);
	int yylex(void);
	void yyerror(FILE* fp, char* s);

	extern int yylex_init(yyscan_t* scanner);
	extern int yyset_in(FILE* inputFile, yyscan_t* scanner);
	extern int yylex_destroy(yyscan_t* scanner);

	int parseFile(const char* filePath);
	extern struct yy_buffer_state* yy_scan_string(char* str);
	extern void yy_delete_buffer(struct yy_buffer_state* buffer);
%}
%parse-param { FILE* fp }

%start program

%token EOL
%token AT
%token DOT
%token COMMA
%token OPEN_PARENTH
%token CLOSE_PARENTH
%token OPEN_SQUARE_BRACKET
%token CLOSE_SQUARE_BRACKET
%token OPEN_ANGLE
%token CLOSE_ANGLE
%token EQUALS
%token RETURNS
%token GETS
%token NUMBER
%token REAL
%token BOOLEAN_VALUE
%token FUNCTION_PURITY
%token PRIMITIVE_TYPE
%token ACCESS_MODIFIER
%token OPEN_COMMENT
%token CLOSE_COMMENT
%token QUESTION_MARK
%token COLON
%token BINARY_OPERATOR
%token VOID
%token CHARACTER
%token STRING
%token NAME
%token WHITESPACE

// %left "=>" "<=>"
// %left "||"
// %left "&&"
%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMINUS	/*supplies precedence for unary minus */

%%									 /* beginning of rules section */
program: line | line EOL program;
line: startLineWhiteSpace lineContents;
startLineWhiteSpace:
				   | WHITESPACE startLineWhiteSpace;
lineContents: | functionalLine | functionDeclarationLine;
functionalLine: impureFunctionCall | assignment;
functionDeclarationLine: FUNCTION_PURITY type NAME OPEN_PARENTH parameters CLOSE_PARENTH RETURNS returnType;
type: PRIMITIVE_TYPE
	| type OPEN_ANGLE type_list_non_zero CLOSE_ANGLE
	| OPEN_PARENTH type_list CLOSE_PARENTH
	| OPEN_SQUARE_BRACKET type_list CLOSE_SQUARE_BRACKET
	| NAME;
type_list: 
		 | type COMMA type_list;
type_list_non_zero: type
				  | type COMMA type_list_non_zero;
parameters: 
		  | parameters_non_zero;
parameters_non_zero: parameter
				   | parameter COMMA parameters_non_zero;
parameter: type NAME;
returnType: type
		  | VOID;

assignment: variable GETS expression;

expression: value
		  | functionCall
		  | expression expression_tail;
value: NUMBER
	 | BOOLEAN_VALUE
	 | CHARACTER
	 | STRING
	 | variable;
functionCall: pureFunctionCall
			| impureFunctionCall;
impureFunctionCall: AT pureFunctionCall;
pureFunctionCall: NAME OPEN_PARENTH arguments CLOSE_PARENTH;
expression_tail: QUESTION_MARK expression COLON expression
			   | BINARY_OPERATOR expression;
arguments: 
		 | args_non_zero;
args_non_zero: argument
			 | argument COMMA args_non_zero;
argument: expression;
variable: NAME 
		| variable OPEN_SQUARE_BRACKET expression CLOSE_SQUARE_BRACKET;
%%

int parseFile(const char* filePath)
{
	// Open the input file (something on disk, or stdin)
	FILE* fp = stdin;
	if (strcmp(filePath, "-") != 0)
	{
		fp = fopen(filePath, "r");
		if (access(filePath, F_OK) != 0)
		{
			fprintf(stderr, "Could not open file '%s'\n", filePath);
			return -1;
		}
		else if(fp == NULL)
		{
			fprintf(stderr, "%s %s %s\n", "File \"", filePath, "does not exist");
			return -2; 
		}
	}

	yyscan_t scanner;	
	// yylex_init(&scanner);
	yyset_in(fp, scanner);
	int returnValue = yyparse(scanner);
	// yylex_destroy(scanner);

	if (fp != stdin)
	{
		fclose(fp);
	}

	return returnValue;
}

extern int main(int argc, char** argv)
{
	if (argc <= 1)
	{
		printf("%s\n", "Where are my inputs?");
		return -1;
	}
	else
	{
		int returnCode = 0;
		for (int i = 1; i < argc; i++)
		{
			printf("%s %s\n", "Handling", argv[i]);
			returnCode |= parseFile(argv[i]);
			if (returnCode != 0)
			{
				break;
			}
		}
		return returnCode;
	}
}

void yyerror(FILE* fp, char* s)
{
	fprintf(stderr, "%s\n",s);
}

int yywrap(void)
{
	return 1;
}
