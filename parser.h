#ifndef _PARSER_H_
#define _PARSER_H_

#include <stdint.h>
#include <stdbool.h>

// wrapper for malloc
#define NEW(typ) ((typ*) calloc(1, sizeof(typ)))
// make iterating over linked lists easy
#define FOREACH(START) for(typeof(*(START)) *__item = (START); __item != NULL; __item = __item->rest)
// prevents forgetting to implement functions
#define MISSING() do { \
	fprintf(stderr, "%s missing at %s:%d\n", __PRETTY_FUNCTION__, __FILE__, __LINE__); \
	exit(1); \
} while (0)

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
	SideEffects *sideEffects;

	struct Block *rest;
} Block;

enum SKind {
	sAssignment,
	sPrint,
	sScan,
	sIf,
	sWhile,
	sBlock,
	sReturn
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
	SideEffects *sideEffects;

	struct Funs *rest;
} Funs;

extern Funs *parse();

struct SideEffects {
	bool direct;

	union {
		char *var;
		SideEffects *indirect;
	};

	struct SideEffects *rest;
};

#endif
