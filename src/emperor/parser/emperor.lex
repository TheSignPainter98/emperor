%{
 
#include <stdio.h>
#include "emperor.tab.hacc"

int c;
extern int yylval;
extern int currentLine;
extern int currentChar;

%}
%%
" "	;
"\n"						{ return EOL; }
"@"							{ return AT; }
"."							{ return DOT; }
","							{ return COMMA; }
"("							{ return OPEN_PARENTH; }
")"							{ return CLOSE_PARENTH; }
"["							{ return OPEN_SQUARE_BRACKET; }
"]"							{ return CLOSE_SQUARE_BRACKET; }
"="							{ return EQUALS; }
"->"						{ return RETURNS; }
"<-"						{ return GETS; }
-?[0-9]+ 	 				{ return NUMBER; }
-?[0-9]+\.[0-9]+ 			{ return REAL; }
pure|impure					{ return FUNCTION_PURITY; }
int|real|boolean			{ return PRIMITIVE_TYPE; }
"/*"						{ return OPEN_COMMENT; }
"*/"						{ return CLOSE_COMMENT; }
"?"							{ return QUESTION_MARK; }
":"							{ return COLON; }
"void"						{ return VOID; }
\'(\\.|[^'\\])\'			{ return CHARACTER; }
\"(\\.|[^"\\])*\"			{ return STRING; }
[A-Za-z£][A-Za-z0-9£]* 		{ return NAME; }
%%
// "+"|"-"|"<"|">"|"!"|"&"|"|"|"*"|"/"|"&&"|"||"|"=="|"!="|"=>"|"<="|">="|"<=>"|">>"|"<<"|"<<<"
// 							{ return BINARY_OPERATOR; }
// 	yylval = *yytext;
// 	return OPERATOR; 
// }
// [lL] {
// 	yylval = *yytext;
// 	return LONG_TAIL;
// }
// \'[a-zA-Z]\' {
// 	c = yytext[0];
// 	yylval = c - 'a';
// 	return LETTER;
// }
// [0-9] {
// 	c = yytext[0];
// 	yylval = c - '0';
// 	return DIGIT;
// }
// public|private|protected {
// 	c = yytext[0];
// 	yylval = c;
// 	return ACCESS_MODIFIER;
// }
// pure {
// 	yylval = *yytext;
// 	return PURITY_PURE;
// }
// impure {
// 	yylval = *yytext;
// 	return PURITY_IMPURE;
// }
// int|bool|real|long|char {
// 	yylval = *yytext;
// 	return PRIMITIVE_TYPE;
// }
// true|false {
// 	yylval = strcmp(yytext, "true") == 0 ? 1 : 0;
// 	return BOOLEAN;
// }
// 0b[01]* {
// 	yylval = atoi(yytext);
// 	// Decode binary here
// 	return BITSEQUENCE_VALUE;
// }
// 0x[0-9A-Fa-f]* {
// 	yylval = atoi(yytext);
// 	// decode hex here
// 	return HEX_VALUE;
// }
// [a-zA-z][a-zA-Z0-9_]* {
// 	yylval = *yytext;
// 	return NAME;
// }
// %%
/**
 * Precondition: the `binary` string consists only of the characters `0` and `1`.
*/
int binaryToIn(const char* binary)
{
	printf("%s\n", binary);
	int value = 0;
	int position = 0x1;
	int i;
	int len = strlen(binary);
	for(i = 0; i < 32; i++)
	{
		if (binary[i] == '1')
		{
			value |= position;
		}
		position <<= 1;
		if (i <= len)
		{
			break;
		}
	}
	return value;
}

int hexadecimalToInt(const char* hexadecimal);
// Keywords: BLOCKS:	if, else, while, for, foreach, repeat,
// Keywords: FUNCTIONS:	pure, impure
// Keywords: MODIFIERS:	public, private, protected
// Keywords: PACKAGES:	package	
