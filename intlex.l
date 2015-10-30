%{
/**
 ** Lexical Analizer for the expression
 **/

#include <stdio.h>
#include <stdlib.h>
#define STRSIZE 64
#include "y.tab.h"
#include "intall.h"

int strcnt = 0;
char string[STRSIZE + 1] = {0};
%}
%start STR COMM
%%
<INITIAL>"+"	return (ADDOP);
<INITIAL>"-"	return (SUBOP);
<INITIAL>"*"	return (MULOP);
<INITIAL>"/"	return (DIVOP);
<INITIAL>"="	return (ASGNOP);
<INITIAL>"=="	return (EQOP);
<INITIAL>">"	return (GTOP);
<INITIAL>">="	return (GEOP);
<INITIAL>"<"	return (LTOP);
<INITIAL>"<="	return (LEOP);
<INITIAL>"!="	return (NTOP);
<INITIAL>"{"	return (LC);
<INITIAL>"}"	return (RC);
<INITIAL>"("	return (LP);
<INITIAL>")"	return (RP);
<INITIAL>";"	return (SM);
<INITIAL>","	return (CM);
<INITIAL>\"		{
					strcnt = 0;
					BEGIN STR;
				}
<INITIAL>"/*"	BEGIN COMM;
<INITIAL>if		return (IF);
<INITIAL>else	return (ELSE);
<INITIAL>while	return (WHILE);
<INITIAL>put	return (PUT);
<INITIAL>get	return (GET);
<INITIAL>[a-z]	{
					yylval.idno = yytext[0] - 'a';
					return (IDENT);
				}
<INITIAL>[0-9]+	{
					yylval.num = atoi((char *)yytext);
					return (NUMBER);
				}
<INITIAL>[ \t\n]	;
<INITIAL>[a-z0-9]+	lexerror("word invalid");
<INITIAL>.			lexerrror("character invalid");
<STR>\"			{
					if (strcnt >= STRSIZE) {
						lexerror("string too long");
					}
					string[strcnt] = '\0';
					yylval.addr = pool(string);
					BEGIN INITIAL;
					return (STRING);
				}
<STR>\\\"		{
					if (strcnt < STRSIZE) {
						string[strcnt++] = '"';
					}
				}
<STR>\\n		{
					if (strcnt < STRSIZE) {
						string[strcnt++] = '\n';
					}
				}
<STR>\n			{
					lexerror("string not closed");
					string[strcnt] = '\0';
					yylval.addr = pool(string);
					string[strcnt] = '\0';
					yylval.addr = pool(string);
					BEGIN INITIAL;
					return (STRING);
				}
<STR>.			{
					if (strcnt < STRSIZE) {
						string[strcnt++] = yytext[0];
					}
				}
<COMM>"*/"		BEGIN INITIAL;
<COMM>\n		;
<COMM>.			;

%%
/*
 * display a lexical error msg
 */
void lexerror(char *s)
{
	extern int yynerrs, yylineno;

	++yynerrs;
	fprintf(stderr, "%d: %s\n", yylineno, s);
}

