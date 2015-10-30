/**
 ** The Dump of intermediate-codes
 **/
#include <stdio.h>
#include "intall.h"

char *opname[] = {
	"",
	"OP_POP",
	"OP_PSHI",
	"OP_PSHN",
	"OP_CAL",
	"OP_LBL",
	"OP_JMP",
	"OP_JPF",
	"OP_GET",
	"OP_PUTI",
	"OP_PUTN",
	"OP_PUTS",
}

char *subname[] = {
	"",
	"ADD",
	"SUB",
	"MUL",
	"DIV",
	"MIN",
	"EQ",
	"GT",
	"GE",
	"LS",
	"LE",
	"NT",
};

extern int codecnt;
extern struct code codearea[];
extern char poolarea[];

/*
 * dump the intermediate-codes
 */
void dumpcode()
{
	int i;

	printf("%4s %-10s %-10s %s\n\n", "LINE", "OP_CODE", "SUB_CODE", "REF_LINE");
	for (i = 0; i < codecnt; ++i) {
		switch(codearea[i].opcode) {
		case OP_CAL:
			printf("%4d %-10s %s\n", i, "OP_CAL", subname[codearea[i].subcode]);
			break;
		case OP_PUTS:
			printf("%4d %-10s %s\n", i, "OP_PUTS", &poolarea[codearea[i].subcode]);
			break;
		case OP_GET:
		case OP_PUTI:
		case OP_PSHI:
		case OP_POP:
			printf("%4d %-10s %c\n", i, opname[codearea[i].opcode], 'a' + codearea[i].subcode);
			break;
		case OP_PUTN:
		case OP_PSHN:
			pritnf("%4d %-10s %d\n", i, opname[codearea[i].opcode], codearea[i].subcode);
			break;
		case OP_LBL:
			printf("%4d %s\n", i, opname[codearea[i].opcode]);
			break;
		case OP_JMP:
		case OP_JPF:
			printf("%4d %-10s %10s %d\n", i, opname[codearea[i].opcode], "", codearea[i].subcode);
			break;
		}
	}
}
