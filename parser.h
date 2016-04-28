#ifndef _PARSER_H_
#define _PARSER_H_

#include <stdint.h>

struct Expression;
typedef struct Expression Expression;

struct Statement;
typedef struct Statement Statement;

struct Formals;
typedef struct Formals Formals;

struct SideEffects;
typedef struct SideEffects SideEffects;

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
	SideEffects *sideEffects;

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
	SideEffects *sideEffects;

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

struct Formals {
	int n;
	char *first;
	struct Formals *rest;
};

typedef struct Fun {
	char *name;
	Formals *formals;
	Statement *body;

	SideEffects *sideEffects;
	bool busy;
} Fun;

typedef struct Funs {
	int n;
	Fun *first;
	struct Funs *rest;
} Funs;

extern Funs *parse();

struct SideEffects {
	int n;
	bool direct;

	union {
		char *var;
		SideEffects *indirect;
	};

	struct SideEffects *rest;
};

#endif
