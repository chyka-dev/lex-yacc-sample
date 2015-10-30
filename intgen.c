/**
 ** The routines for the intermediate-code
 **/
#include <stdio.h>
#include <string.h>
#include "intall.h"
#define CODESIZE 1000
#define POOLSIZE 200
#define LBLSIZE 100

int codecnt = 0;
struct code codearea[CODESIZE] = {0};
int poolcnt = 0;
char poolarea[POOLSIZE] = {0};
int labelno = 0;
int lbltable[LBLSIZE] = {0};

/*
 * generate an intermediate-code
 */
void gencode(int op, int sub)
{
	if (codecnt >= CODESIZE) {
		fatal("codearea overflow");
	}
	codearea[codecnt].opcode = op;
	codearea[codecnt++].subcode = sub;
}

/*
 * pool a string
 */
int pool(char *p)
{
	int i, j;

	j = poolcnt;
	if ((i = poolcnt + strlen(p) + 1) > POOLSIZE) {
		fatal("poolarea overflow");
	}
	strcpy(&poolarea[poolcnt], p);
	poolcnt = i;
	return (j);
}

/*
 * create a new label
 */
int newlbl()
{
	if (labelno >= LBLSIZE) {
		fatal("lbltable overflow");
	}
	return (labelno++);
}

/*
 * resolve the reference of the labels
 */
void defref()
{
	int i;

	for (i = 0; i < codecnt; i++) {
		if (codeare[i].opcode == OP_LBL) {
			lbltable[codearea[i].subcode] = i;
		}
	}

	for (i = 0; i < codecnt; i++) {
		if (codearea[i].opcode == OP_JMP ||
			codearea[i].subcode == OP_JPF) {
			codearea[i].subcode = lbltable[codearea[i].subcode];
		}
	}
}

