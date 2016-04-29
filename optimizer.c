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

void resolveSideEffectsFun(Fun *function) {
	if(function->busy || function->sideEffects != NULL) {
		return;
	}

	function->busy = true;

	resolveSideEffectsStatement(function->body, function->formals);

	SideEffects *s = (function->sideEffects = NEW(SideEffects));

	s->parentKind = pFun;
	s->fParent = function;

	function->hasSideEffects |= function->body->hasSideEffects;
	s->direct = false;
	s->indirect = function->body->sideEffects;

	function->busy = false;
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
	s->parentKind = pStatement;
	s->sParent = statement;

	switch(statement->kind) {
		case sAssignment: {
			statement->hasSideEffects = true;
			s->direct = true;
			s->var = statement->assignName;

			Expression *e = statement->assignValue;
			resolveSideEffectsExpression(e, scope);

			s = (s->rest = NEW(SideEffects));

			s->parentKind = pStatement;
			s->sParent = statement;

			s->direct = false;
			s->indirect = e->sideEffects;
		} break;

		case sPrint: {
			statement->hasSideEffects = true;
			s->direct = true;
			s->var = NULL;

			Expression *e = statement->printValue;
			resolveSideEffectsExpression(e, scope);

			s = (s->rest = NEW(SideEffects));

			s->parentKind = pStatement;
			s->sParent = statement;

			s->direct = false;
			s->indirect = e->sideEffects;
		} break;

		case sScan: {
			statement->hasSideEffects = true;
			s->direct = true;
			s->var = statement->scanVar;
		} break;

		case sIf: {
			Expression *e = statement->ifCondition;
			resolveSideEffectsExpression(e, scope);

			statement->hasSideEffects |= e->hasSideEffects;
			s->direct = false;
			s->indirect = e->sideEffects;

			Statement *thenStatement = statement->ifThen;
			resolveSideEffectsStatement(thenStatement, scope);

			s = (s->rest = NEW(SideEffects));

			s->parentKind = pStatement;
			s->sParent = statement;

			statement->hasSideEffects |= thenStatement->hasSideEffects;
			s->direct = false;
			s->indirect = thenStatement->sideEffects;

			Statement *elseStatement = statement->ifElse;
			if(elseStatement != NULL) {
				resolveSideEffectsStatement(elseStatement, scope);

				s = (s->rest = NEW(SideEffects));

				s->parentKind = pStatement;
				s->sParent = statement;

				statement->hasSideEffects |= elseStatement->hasSideEffects;
				s->direct = false;
				s->indirect = elseStatement->sideEffects;
			}
		} break;

		case sWhile: {
			Expression *e = statement->whileCondition;
			resolveSideEffectsExpression(e, scope);

			statement->hasSideEffects |= e->hasSideEffects;
			s->direct = false;
			s->indirect = e->sideEffects;

			Statement *loopStatement = statement->whileBody;
			resolveSideEffectsStatement(loopStatement, scope);

			s = (s->rest = NEW(SideEffects));

			s->parentKind = pStatement;
			s->sParent = statement;

			statement->hasSideEffects |= loopStatement->hasSideEffects;
			s->direct = false;
			s->indirect = loopStatement->sideEffects;
		} break;

		case sBlock: {
			Block *b = statement->block;
			if(b != NULL && b->first != NULL) {
				resolveSideEffectsStatement(b->first, scope);

				statement->hasSideEffects |= b->first->hasSideEffects;
				s->direct = false;
				s->indirect = b->first->sideEffects;

				FOREACH(b->rest) {
					resolveSideEffectsStatement(__item->first, scope);

					s = (s->rest = NEW(SideEffects));

					s->parentKind = pStatement;
					s->sParent = statement;

					statement->hasSideEffects |= __item->first->hasSideEffects;
					s->direct = false;
					s->indirect = __item->first->sideEffects;
				}
			}
		} break;

		case sReturn: {
			statement->hasSideEffects = true;
			s->direct = true;
			s->var = NULL;

			Expression *e = statement->returnValue;
			resolveSideEffectsExpression(e, scope);

			s = (s->rest = NEW(SideEffects));

			s->parentKind = pStatement;
			s->sParent = statement;

			statement->hasSideEffects |= e->hasSideEffects;
			s->direct = false;
			s->indirect = e->sideEffects;
		} break;
	}
}

void resolveSideEffectsExpression(Expression *expression, Formals *scope) {
	if(expression->sideEffects != NULL) {
		return;
	}

	SideEffects *s = (expression->sideEffects = NEW(SideEffects));

	s->parentKind = pExpression;
	s->eParent = expression;

	if(expression->kind != eCALL) {
		expression->hasSideEffects = false;
		return;
	}

	Actuals *a = expression->callActuals;
	if(a != NULL && a->first != NULL) {
		resolveSideEffectsExpression(a->first, scope);

		expression->hasSideEffects |= a->first->hasSideEffects;
		s->direct = false;
		s->indirect = a->first->sideEffects;

		FOREACH(a->rest) {
			resolveSideEffectsExpression(__item->first, scope);

			s = (s->rest = NEW(SideEffects));

			s->parentKind = pExpression;
			s->eParent = expression;

			expression->hasSideEffects |= __item->first->hasSideEffects;
			s->direct = false;
			s->indirect = __item->first->sideEffects;
		}
	}

	Fun *f = getFunByName(expression->callName);
	resolveSideEffectsFun(f);

	s = (s->rest = NEW(SideEffects));

	s->parentKind = pExpression;
	s->eParent = expression;

	expression->hasSideEffects |= f->hasSideEffects;
	s->direct = false;
	s->indirect = f->sideEffects;
}
