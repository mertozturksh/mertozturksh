/* Infix notation calculator using Bison */

%{

#define YYSTYPE double

#include <stdio.h>
#include <math.h>
#include <ctype.h>

int yylex (void);
void yyerror (char const *);

%}

%token NUM

%left '+' '-'
%left '*' '/'
%right '^'
%right 'n'

%%

input:
	/* empty */
	| input line
	;

line:
	'\n'
	| exp '\n' { printf ("\t%.10g\n", $1); }
	;

exp: NUM { $$ = $1; }
| exp '+' exp { $$ = $1 + $3; }
| exp '-' exp { $$ = $1 - $3; }
| exp '*' exp { $$ = $1 * $3; }
| exp '/' exp { $$ = $3 == 0 ? (yyerror("Division by zero"), 0) : $1 / $3; }
/* Exponentiation */
| exp '^' exp { $$ = pow ($1, $3); }
/* Unary minus */
| 'n' exp { $$ = -$2; }
/* Parentheses */
| '(' exp ')' { $$ = $2; }
;

%%

/* The lexical analyzer returns a double floating point
number on the stack and the token NUM, or the numeric code
of the character read if not a number. It skips all blanks
and tabs, and returns 0 for end-of-input. */

int
yylex (void)
{
int c;
/* Skip white space. */
while ((c = getchar ()) == ' ' || c == '\t')
;
/* Process numbers. */
if (c == '.' || isdigit (c))
{
ungetc (c, stdin);
scanf ("%lf", &yylval);
return NUM;
}
/* Return end-of-input. */
if (c == EOF)
return 0;
/* Return a single char. */
return c;
}

/* Called by yyparse on error. */
void
yyerror (char const *s)
{
fprintf (stderr, "%s\n", s);
}

int
main (void)
{
return yyparse ();
}	
