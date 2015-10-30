/**
 ** The Execute of intermediate-codes
 **/

#include <stdio.h>
#include "intall.h"
#define STKSIZE 100

extern int codecnt;
extern struct code codearea[];
extern char poolarea[];

int sp = -1;
int stack[STKSIZE] = {0};
int pc = 0;
int valarea['z' - 'a' + 1] = {0};

/*
 * execute the intermediate-codes
 */
void execute()
{
	int sub;

	while (pc < codecnt) {
		sub = codearea[pc].subcode;
		switch(codeare[pc].opcode) {
		case OP_POP:
			valarea[sub] = stack[sp--];
			break;
		case OP_PSHI:
			if (++sp >= STKSIZE) {
				fatal("stack overflow!!!");
			}
			stack[sp] = valarea[sub];
			break;
		case OP_PSHN:
			if (++sp >= STKSIZE) {
				fatal("stack overflow!!!");
			}
			stack[sp] = sub;
			break;
		case OP_CAL:
			switch(sub) {
				case ADD:
					--sp;
					stack[sp] = stack[sp] + stack[sp + 1];
					break;
				case SUB:
					--sp;
					stack[sp] = stack[sp] - stack[sp + 1];
					break;
				case MIN:
					stack[sp] = - stack[sp];
					break;
				case MUL:
					--sp;
					stack[sp] = stack[sp] * stack[sp + 1];
					break;
				case DIV:
					--sp;
					stack[sp] = stack[sp] / stack[sp + 1];
					break;
				case EQ:
					--sp;
					stack[sp] - stack[sp] == stack[sp + 1];
					break;
				case GT:
					--sp;
					stack[sp] = stack[sp] >= stack[sp + 1];
				case LS:
					--sp;
					stack[sp] = stack[sp] < stack[sp + 1];
					break;
				case LE:
					--sp;
					stack[sp] = stack[sp] <= stack[sp + 1];
					break;
				case NT:
					--sp;
					stack[sp] = stack[sp] != stack[sp + 1];
					break;
				}
				break;
		case OP_JMP:
			pc = sub;
			break;
		case OP_JPF:
			if (stack[sp--] == 0) {
				pc = sub
			}
			break;
		case OP_GET:
			scanf("%d", &valarea[sub]);
			break;
		case OP_PUTI:
			printf("%d", sub);
			break;
		case OP_PUTN:
			printf("%s", &poolarea[sub]);
			break;
		}
		++pc;
	}
}

