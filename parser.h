#ifndef _PARSER_H_
#define _PARSER_H_

#include <stdint.h>
#include <stdbool.h>

#define NEW(typ) ((typ*)calloc(1, sizeof(typ)))

// make iterating over linked lists easy
#define FOREACH(START) for(typeof(*(START)) *__item = (START); __item != NULL; __item = __item->rest)

// void (list<T> **, T *)
#define STACK_PUSH(stack, item) ({ \
	typeof(*(stack)) __new_node = NEW(typeof(**(stack))); \
	__new_node->first = (item); \
	__new_node->rest = *(stack); \
	*(stack) = __new_node; \
})

// T *(list<T> **)
#define STACK_POP(stack) ({ \
	typeof(*(stack)) __top_node = *(stack); \
	*(stack) = __top_node->rest; \
	__top_node->first; \
})

struct Expression;
typedef struct Expression Expression;

struct Statement;
typedef struct Statement Statement;

typedef struct Var {
	char *name;
	bool local;
} Var;

typedef struct Vars {
	Var *first;
	struct Vars *rest;
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
	Semantics *semantics;
	bool needed;
    bool processed;
    bool absolute;
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
	struct Statements *rest;
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
