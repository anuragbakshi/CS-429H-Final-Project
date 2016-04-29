#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "optimizer.h"
#include "parser.h"

Fun *getFunByName(char *name) {
	FOREACH(functions) {
		if(strcmp(__item->first->name, name) == 0) {
			return __item->first;
		}
	}

	return NULL;
}

void optimize() {
	FOREACH(functions) resolveSideEffectsFun(__item->first);
}

void resolveSideEffectsFun(Fun *f) {
	if(f->busy || f->sideEffects != NULL) {
		return;
	}

	f->busy = true;

	resolveSideEffectsStatement(f->body, f->formals);

	SideEffects *s = (f->sideEffects = NEW(SideEffects));
	s->direct = false;
	s->indirect = f->body->sideEffects;

	f->busy = false;
}

// void resolveSideEffectsActuals(Actuals *actuals) {
// 	MISSING();
// }

// void resolveSideEffectsBlock(Block *block) {
// 	MISSING();
// }

void resolveSideEffectsStatement(Statement *statement, Formals *scope) {
	if(statement->sideEffects != NULL) {
		return;
	}

	SideEffects *s = (statement->sideEffects = NEW(SideEffects));

	switch(statement->kind) {
		case sAssignment: {
			s->direct = true;
			s->var = statement->assignName;

			Expression *e = statement->assignValue;
			resolveSideEffectsExpression(e, scope);

			s = (s->rest = NEW(SideEffects));
			s->direct = false;
			s->indirect = e->sideEffects;
		} break;

		case sPrint: {
			s->direct = true;
			s->var = NULL;

			Expression *e = statement->printValue;
			resolveSideEffectsExpression(e, scope);

			s = (s->rest = NEW(SideEffects));
			s->direct = false;
			s->indirect = e->sideEffects;
		} break;

		case sScan: {
			s->direct = true;
			s->var = statement->scanVar;
		} break;

		case sIf: {
			Expression *e = statement->ifCondition;
			resolveSideEffectsExpression(e, scope);

			s->direct = false;
			s->indirect = e->sideEffects;

			Statement *thenStatement = statement->ifThen;
			resolveSideEffectsStatement(thenStatement, scope);

			s = (s->rest = NEW(SideEffects));
			s->direct = false;
			s->indirect = thenStatement->sideEffects;

			Statement *elseStatement = statement->ifElse;
			if(elseStatement != NULL) {
				resolveSideEffectsStatement(elseStatement, scope);

				s = (s->rest = NEW(SideEffects));
				s->direct = false;
				s->indirect = elseStatement->sideEffects;
			}
		} break;

		case sWhile: {
			Expression *e = statement->whileCondition;
			resolveSideEffectsExpression(e, scope);

			s->direct = false;
			s->indirect = e->sideEffects;

			Statement *loopStatement = statement->whileBody;
			resolveSideEffectsStatement(loopStatement, scope);

			s = (s->rest = NEW(SideEffects));
			s->direct = false;
			s->indirect = loopStatement->sideEffects;
		} break;

		case sBlock: {
			Block *b = statement->block;
			if(b != NULL && b->first != NULL) {
				resolveSideEffectsStatement(b->first, scope);

				s->direct = false;
				s->indirect = b->first->sideEffects;

				FOREACH(b->rest) {
					resolveSideEffectsStatement(__item->first, scope);

					s = (s->rest = NEW(SideEffects));
					s->direct = false;
					s->indirect = __item->first->sideEffects;
				}
			}
		} break;

		case sReturn: {
			s->direct = true;
			s->var = NULL;

			Expression *e = statement->returnValue;
			resolveSideEffectsExpression(e, scope);

			s = (s->rest = NEW(SideEffects));
			s->direct = false;
			s->indirect = e->sideEffects;
		} break;
	}
}

void resolveSideEffectsExpression(Expression *expression, Formals *scope) {
	if(expression->kind != eCALL || expression->sideEffects != NULL) {
		return;
	}

	SideEffects *s = (expression->sideEffects = NEW(SideEffects));

	Actuals *a = expression->callActuals;
	if(a != NULL && a->first != NULL) {
		resolveSideEffectsExpression(a->first, scope);

		s->direct = false;
		s->indirect = a->first->sideEffects;

		FOREACH(a->rest) {
			resolveSideEffectsExpression(__item->first, scope);

			s = (s->rest = NEW(SideEffects));
			s->direct = false;
			s->indirect = __item->first->sideEffects;
		}
	}

	Fun *f = getFunByName(expression->callName);
	resolveSideEffectsFun(f);

	s = (s->rest = NEW(SideEffects));
	s->direct = false;
	s->indirect = f->sideEffects;
}
