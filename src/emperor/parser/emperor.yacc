%{
	#include <stdio.h>
	#include <stdlib.h>
	int currentLine = 1;
	int currentChar = 1;
	int main(int argc, char** argv);
	int yylex(void);
	void yyerror(FILE* fp, char* s);

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
	| NAME;
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

int parseString(char* inputString)
{
	struct yy_buffer_state* buffer = yy_scan_string(inputString);
	int retval = yyparse(NULL);
	yy_delete_buffer(buffer);
	return retval;
}

/**
 * Precondition: The file in `filepath` exists
*/
int parseFile(const char* filePath)
{
	FILE* fp = fopen(filePath, "r");

	if (fp != NULL)
	{
		// THERE'S DEFINITELY A BETTER WAY OF DOING THIS!!
		char * buffer = NULL;
		long length;

		fseek(fp, 0, SEEK_END);
		length = ftell(fp);
		fseek(fp, 0, SEEK_SET);
		buffer = malloc(length);

		if (buffer != NULL)
		{
			fread(buffer, 1, length, fp);
		}

		fclose(fp);

		if (buffer != NULL)
		{
			// start to process your data / extract strings here...
			int returnVal = parseString(buffer);
			free(buffer);
			return returnVal;
		}
		else
		{
			fprintf(stderr, "%s\n", "Could not read things in to buffer");
			return -10;
		}
	}
	else
	{
		fprintf(stderr, "%s %s\n", "Could not read input file,", filePath);
		return -11;
	}
}

int main(int argc, char** argv)
{
	if (argc <= 1)
	{
		printf("%s\n", "Where are my inputs?");
		return -1;
	}
	else
	{
		if (argc >= 3)
		{
			printf("%s %d %s\n", "Early version, got", argc, "arguments, ignoring second and after :(");
		}
		return parseFile(argv[1]);
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
