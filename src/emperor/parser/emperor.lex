%{
 
#include <stdio.h>
#include "y.tab.h"
int c;
extern int yylval;
%}
%%
" "       ;
[lL] {
	yylval = *yytext;
	return(LONG_TAIL);
}
[a-z] {
	c = yytext[0];
	yylval = c - 'a';
	return(LETTER);
}
[0-9] {
	c = yytext[0];
	yylval = c - '0';
	return(DIGIT);
}
(public|private|protected) {
	c = yytext[0];
	yylval = c;
	return(ACCESS_MODIFIER);
}
pure {
	yylval = *yytext;
	return(PURITY_PURE);
}
impure {
	yylval = *yytext;
	return(PURITY_IMPURE);
}
(int|bool|real|long|char) {
	yylval = *yytext;
	return(PRIMITIVE_TYPE);
}
(true|false) {
	yylval = *yytext;
	return(BOOLEAN);
}
[01]* {
	yylval = atoi(yytext);
	return(BITSEQUENCE_VALUE);
}
[0-9A-Fa-f]* {
	yylval = atoi(yytext);
	return(HEX_VALUE);
}
[a-zA-z][a-zA-Z0-9_]* {
	yylval = *yytext;
	return(NAME);
}
