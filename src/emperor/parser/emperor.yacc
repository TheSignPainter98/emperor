%{
	#include <stdio.h>
	int currentLine = 1;
	int currentChar = 1;
	int main(void);
	int yylex(void);
	void yyerror(char* s);

	extern struct yy_buffer_state* yy_scan_string(char * str);
	extern void yy_delete_buffer(struct yy_buffer_state* buffer);
%}
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
%token FUNCTION_PURITY
%token PRIMITIVE_TYPE
%token OPEN_COMMENT
%token CLOSE_COMMENT
%token QUESTION_MARK
%token COLON
%token BINARY_OPERATOR
%token VOID
%token CHARACTER
%token STRING
%token NAME

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
line: | functionalLine | functionDeclarationLine;
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
	 | variable
	 | CHARACTER
	 | STRING;
functionCall: pureFunctionCall
			| impureFunctionCall;
impureFunctionCall: AT pureFunctionCall;
pureFunctionCall: NAME OPEN_PARENTH arguments CLOSE_PARENTH;
expression_tail: BINARY_OPERATOR expression
			   | QUESTION_MARK expression COLON expression;
arguments: 
		 | args_non_zero;
args_non_zero: argument
			 | argument COMMA args_non_zero;
argument: expression;
variable: NAME 
		| variable OPEN_SQUARE_BRACKET expression CLOSE_SQUARE_BRACKET;
%%

int main(void)
{
	// char* inputString = "asdf[asdf[12]] <- asdf\n";
	// printf("Running on string: '%s'\n", inputString);
	// struct yy_buffer_state* buffer = yy_scan_string(inputString);
	// int retval = yyparse();
	// yy_delete_buffer(buffer);
	// return retval;
	// printf("%s", "Type string for input > ");
	return yyparse();
}

void yyerror(char* s)
{
	fprintf(stderr, "%s\n",s);
}

int yywrap(void)
{
	return 1;
}
