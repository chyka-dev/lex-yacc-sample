typedef union {
	int idno;
	int num;
	int addr;
	int label;
	struct node *nodep;
} YYSTYPE;

extern YYSTYPE yylval;
#define IDENT 257
#define NUMBER 258
#define STRING 259
#define IF 260
#define ELSE 261
#define WHILE 262
#define GET 263
#define PUT 264
#define LP 265
#define PR 266
#define LC 267
#define RC 268
#define SM 269
#define CM 270
#define ASGNOP 271
#define EQOP 272
#define GTOP 273
#define GEOP 274
#define LSOP 275
#define LEOP 276
#define NTOP 277
#define ADDOP 278
#define SUBOP 279
#define MULOP 280
#define DIVOP 281
#define MINUS 282

