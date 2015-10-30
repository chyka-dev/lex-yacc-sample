%{
/**
 **   analyze the syntax of the expression
 **/

#include <stdio.h>
#include "intall.h"

#define ID 100
#define NUM 101
#define STR 102
#define NODESIZE 100
int nodecnt = 0; //TODO なんのために数えるのか
struct node { //TODO 
  int ntype;
  int nvalue;
  struct node *left;
  struct node *right;
} nodearea[NODESIZE] = {0};
%}
%union { //TODO
  int idno;
  int num;
  int addr;
  int label;
  struct node *nodep;
}
%token <idno> IDENT
%token <num> NUMBER
%token <addr> STRING
%token IF ELSE WHILE GET PUT
%token LP RP
%token LC RC
%token SM CM
%token ASGNOP
%token EQOP GTOP GEOP LSOP LEOP NTOP
%left ADDOP SUBOP
%left MULOP DIVOP
%right MINUS
%type <label> if.prefix while.prefix
%type <nodep> expr cond
%%
s	:	stmt.list
	;
stmt.list
	:	/* empty */ 
	|	stmt.list stmt
	;
stmt
	:	IDENT ASGNOP expr SM
	{
		genexpr($3);
		clearnode();
		gencode(OP_POP, $1);
	}
	| if.prefix stmt
	{
		gencode(OP_LBL, $1);
	}
	| if.prefix stmt ELSE
	{
		gencode(OP_JMP, $<label>$ = newlbl());
		gencode(OP_LBL, $1);
	}
	  stmt
	{
		gencode(OP_LBL, $<label>4);
	}
	| while.prefix
	{
		gencode(OP_JPF, $<label>$ = newlbl());
	}
	  stmt
	{
		gencode(OP_JMP, $1);
		gencode(OP_LBL, $<label>2);
	}
	| PUT LP put.list RP SM
	| GET LP IDENT RP SM
	{
		gencode(OP_GET, $3);
	}
	| LC stmt.list RC
	| SM
	| error SM
	{
		yyerrok;
		clearnode();
	}
	| error SM
	{
		yyerrok;
		clearnode();
	}
	| error RC
	{
		yyerrok;
		clearnode();
	}
	;
if.prefix
	: IF LP cond RP
	{
		genexpr($3);
		clearnode();
		gencode(OP_JRF, $$ = newlbl());
	}
	;
while.prefix
	: WHILE LP cond RP
	{
		gencode(OP_LBL, $$ = newlbl());
		genexpr($3);
		clearnode();
	}
	;
put.list
	: id.num.or.str
	| put.list CM id.num.or.str
	;
id.num.or.str
	: IDENT
	{
		gencode(OP_PUTI, $1);
	}
	| NUMBER
	{
		gencode(OP_PUTN, $1);
	}
	| STRING
	{
		gencode(OP_PUTS, $1);
	}
	;
cond
	: expr EQOP expr
	{
		 $$ = makeexpr(EQ, $1, $3);
	}
	| expr GTOP expr
	{
		$$ = makeexpr(GT, $1, $3);
	}
	| expr GEOP expr
	{
		$$ = makeexpr(GE, $1, $3);
	}
	| expr LSOP expr
	{
		$$ = makeexpr(LS, $1, $3);
	}
	| expr LEOP expr
	{
		$$ = makeexpr(LE, $1, $3);
	}
	| expr NTOP expr
	{
		$$ = makeexpr(NT, $1, $3);
	}
expr
	: expr ADDOP expr
	{
		$$ = makeexpr(ADD, $1, $3);
	}
	| expr SUBOP expr
	{
		$$ = makeexpr(SUB, $1, $3);
	}	
	| expr MULOP expr
	{
		$$ = makeexpr(MUL, $1, $3);
	}
	| expr DIVOP expr
	{
		$$ = makeexpr(DIV, $1, $3);
	}
	| SUBOP expr %prec MINUS
	{
		$$ = makeexpr(MIN, $2, 0);
	}
	| LP expr RP
	{
		$$ = $2;
	}
	| IDENT
	{
		$$ = makenode(ID, $1);
	}
	| NUMBER
	{
		$$ = makenode(NUM, $1);
	}
	;
%%
/*
 * display an error msg
 */
void yyerror(char  *s)
{
	extern int yylineno;
	fprintf(stderr, "%d: %s\n", yylineno, s);
}

/*
 * clear the nodearea
 */
void clearnode()
{
	nodecnt = 0;
}

/*
 * get the memory for the node
 */
struct node *getnode()
{
	if (nodecnt >= NODESIZE) {
		fatal("nodearea overflow");
	}
	return (&nodearea[nodecnt++]);	
}

/*
 * make a node
 */
struct node *makenode(int type, int value)
{
	struct node *p;
	
	p = getnode();
	p->ntype = type;
	p->nvalue = value;
	p->left = NULL;
	p->right = NULL;
	return (p); //TODO このかっこはなんだ？
}

/*
 * make the tree for expression
 */
struct node *makeexpr(int type, struct node *lft, struct node *rgt)
{
	struct node *p;

	p = makenode(type, 0);
	p->left = lft;
	p->right = rgt;
	return (p);
}

/*
 * generate the intermediate-code of expression
 */
void genexpr(struct node *p)
{
	if (p == NULL) {
		return;
	}
	if (p->left) {
		genexpr(p->left);
	}
	if (p->right) {
		genexpr(p->right);
	}
	switch (p->ntype) {
	case ID:
		gencode(OP_PSHI, p->nvalue);
		break;
	case NUM:
		gencode(OP_PSHN, p->nvalue);
		break;
	default:
		gencode(OP_CAL, p->ntype);
		break;
	}	

