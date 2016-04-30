#ifndef _PARSER_H_
#define _PARSER_H_

#include <stdint.h>
#include <stdbool.h>

struct Expression;
typedef struct Expression Expression;

struct Statement;
typedef struct Statement Statement;

typedef struct Var {
	char *name;
	bool local;
} Var;

typedef struct Vars {
	Var var;
	struct Vars *next;
} Vars;

typedef struct Semantics {
	Vars *modifies;
	Vars *depends;
	bool anchor;
} Semantics;

typedef struct Actuals {
	int n;
	Expression *first;
	struct Actuals *rest;
} Actuals;

enum EKind {
	eVAR,
	eVAL,
	ePLUS,
	eMINUS,
	eMUL,
	eDIV,
	eEQ,
	eNE,
	eLT,
	eGT,
	eCALL
};

struct Expression {
	enum EKind kind;
	union {
		/* EVAR */ char *varName;
		/* EVAL */ uint64_t val;
		/* EPLUS, EMUL, ... */ struct {
			Expression *left;
			Expression *right;
		};
		/* ECALL */ struct {
			char *callName;
			Actuals *callActuals;
		};
	};
};


typedef struct Block {
	int n;
	Statement *first;
	struct Block *rest;
} Block;

typedef struct While {
	Expression *condition;
	Statement *body;
} While;

typedef struct If {
	Expression *condition;
	Statement *thenPart;
	Statement *elsePart;
} If;

typedef struct Print {
	Expression *expression;
} Print;

enum SKind {
	sAssignment,
	sPrint,
	sScan,
	sIf,
	sWhile,
	sBlock,
	sReturn,
};

struct Statement {
	enum SKind kind;
	Semantics semantics;
	union {
		struct {
			char *assignName;
			Expression *assignValue;
		};
		Expression *printValue;
		char *scanVar;
		struct {
			Expression *ifCondition;
			Statement *ifThen;
			Statement *ifElse;
		};
		struct {
			Expression *whileCondition;
			Statement *whileBody;
		};
		Block *block;
		Expression *returnValue;
	};
};

typedef struct Statements {
	Statement *first;
	struct Statemens *rest;
} Statements;

typedef struct Formals {
	int n;
	char *first;
	struct Formals *rest;
} Formals;

typedef struct Fun {
	char *name;
	Formals *formals;
	Statement *body;
} Fun;

typedef struct Funs {
	int n;
	Fun *first;
	struct Funs *rest;
} Funs;

extern Funs *parse();

#endif
