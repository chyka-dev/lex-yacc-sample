#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "intall.h"

extern int yynerrs; //TODO
extern FILE *yyin; //TODO
int dmpflag = 0; //TODO
#ifdef YYDEBUG
extern int yydebug; //TODO
#endif

/*
 * interpret the expresion
 */
int main(int ac, char *av[])
{
	if (ac < 2) {
		fatal("option error");
	}

	if (!(yyin = fopen(av[1], "r"))) {
		fatal("open error");
	}

	if (ac >= 3 && !strcmp(av[2], "-d")) {
		dmpflag = 1;
#ifdef YYDEBUG
		yydebug = 1;
#endif
	}

	if (yyparse() || yynerrs) {
		fatal("not executed");
	}
	defref();//TODO
	if (dmpflag) {
		dumpcode();
	}
	execute(); 
}


//TODO prototype宣言いらないの？ -> intall.hにある
/*
 * cause the fatal error
 */
void fatal(char *s)
{
	fprintf(stderr, "%s!!!\n", s);
	exit(0);
}

