%{
#include <stdio.h>
int regs[26];
int base;
%}
// %start list
// %start list
%start typein
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
%left UMINUS  /*supplies precedence for unary minus */
%%                   /* beginning of rules section */
typein: functioncall '\n';
primitive_constant: number | real | BOOLEAN | bitsSequence | long;
value: NAME | primitive_constant;
valuelist: value | value ',' valuelist;
maybevaluelist: | valuelist;
functioncall: NAME '(' maybevaluelist ')';
stat:    expr
         {
           printf("%d\n",$1);
         }
         |
         LETTER '=' expr
         {
           regs[$1] = $3;
         }
         ;
expr:    '(' expr ')'
         {
           $$ = $2;
         }
         |
         expr '*' expr
         {
           $$ = $1 * $3;
         }
         |
         expr '/' expr
         {
           $$ = $1 / $3;
         }
         |
         expr '%' expr
         {
           $$ = $1 % $3;
         }
         |
         expr '+' expr
         {
           $$ = $1 + $3;
         }
          |
         expr '-' expr
         {
           $$ = $1 - $3;
         }
         |
         expr '&' expr
         {
           $$ = $1 & $3;
         }
         |
         expr '|' expr
         {
           $$ = $1 | $3;
         }
         |
        '-' expr %prec UMINUS
         {
           $$ = -$2;
         }
         |
         LETTER
         {
           $$ = regs[$1];
         }
         |
         number
         ;
number:  DIGIT
         {
           $$ = $1;
           base = ($1==0) ? 8 : 10;
         }       |
         number DIGIT
         {
           $$ = base * $1 + $2;
         }
         ;
real:	number '.' number;
bitsSequence: '0x' HEX_VALUE | '0b' BITSEQUENCE_VALUE;
long:	number LONG_TAIL;

type: 	PRIMITIVE_TYPE | NAME | NAME '<' typelist '>';
typelist:	type | type ',' typelist;
pureFunction:	ACCESS_MODIFIER PURITY_PURE NAME'('type')' '->' type;
impureFunction:	ACCESS_MODIFIER PURITY_IMPURE NAME'('type')' impureReturnAnnotation;
impureReturnAnnotation: | '->' type;

%%

int main()
{
	return(yyparse());
}

void yyerror(s)
char *s;
{
	fprintf(stderr, "%s\n",s);
}

int yywrap()
{
	return(1);
}