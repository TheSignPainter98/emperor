%{
 
#include <stdio.h>
#include "y.tab.h"

int c;
extern int yylval;

%}
%%
" "	;
"."		{ return RADIX_POINT; }
,		{ return LIST_SEPARATOR; }
"("		{ return OPEN_PARENTH; }
)		{ return CLOSE_PARENTH; }
<		{ return OPEN_TYPE_ANNOT ;}
>		{ return CLOSE_TYPE_ANNOT; }
=		{ return DEFAULT_EQUALS; }
->	{ return RETURNS; }
[+-<>!&|*/]|&&|\|\||==|!=|=>|<=|>=|<=>	{ 
	yylval = *yytext;
	return OPERATOR; 
}
[lL] {
	yylval = *yytext;
	return LONG_TAIL;
}
'[a-z]' {
	c = yytext[0];
	yylval = c - 'a';
	return LETTER;
}
[0-9] {
	c = yytext[0];
	yylval = c - '0';
	return DIGIT;
}
public|private|protected {
	c = yytext[0];
	yylval = c;
	return ACCESS_MODIFIER;
}
pure {
	yylval = *yytext;
	return PURITY_PURE;
}
impure {
	yylval = *yytext;
	return PURITY_IMPURE;
}
int|bool|real|long|char {
	yylval = *yytext;
	return PRIMITIVE_TYPE;
}
true|false {
	yylval = strcmp(*yytext, "true") == 0 ? 1 : 0;
	return BOOLEAN;
}
0b[01]* {
	yylval = atoi(yytext);
	// Decode binary here
	return BITSEQUENCE_VALUE;
}
0x[0-9A-Fa-f]* {
	yylval = atoi(yytext);
	// decode hex here
	return HEX_VALUE;
}
[a-zA-z][a-zA-Z0-9_]* {
	yylval = *yytext;
	return NAME;
}
%%

int binaryToInt(const char* binary);
int hexadecimalToInt(const char* hexadecimal);
// Keywords: BLOCKS:	if, else, while, for, foreach, repeat,
// Keywords: FUNCTIONS:	pure, impure
// Keywords: MODIFIERS:	public, private, protected
// Keywords: PACKAGES:	package	
