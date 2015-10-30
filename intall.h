/**
 ** The Opcode and Subcode
 **/
#define OP_POP 1
#define OP_PSHI 2
#define OP_PSHN 3
#define OP_CAL 4
#define OP_LBL 5
#define OP_JMP 6
#define OP_JPF 7
#define OP_GET 8
#define OP_PUTI 9
#define OP_PUTN 10
#define OP_PUTS 11
#define ADD 1
#define SUB 2
#define MUL 3
#define DIV 4
#define MIN 5
#define EQ 6
#define GT 7
#define GE 8
#define LS 9
#define LE 10
#define NT 11

struct code {
  int opcode;
  int subcode;
};

void fatal(char *);

