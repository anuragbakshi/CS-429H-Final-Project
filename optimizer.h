#ifndef _OPTIMIZER_H_
#define _OPTIMIZER_H_

#include "parser.h"

extern Funs *functions;

extern Fun *getFunByName(char *);

extern void optimize();

extern void resolveSideEffectsFun(Fun *);
// extern void resolveSideEffectsActuals(Actuals *);
// extern void resolveSideEffectsBlock(Block *);
extern void resolveSideEffectsStatement(Statement *, Formals *);
extern void resolveSideEffectsExpression(Expression *, Formals *);

#endif
