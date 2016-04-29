#include <stdio.h>
#include "debug.h"

void printSideEffects(SideEffects *sideEffects) {
	// printf("%d\n", sideEffects->direct);
	// printf("%s\n", sideEffects->var);
	// printf("%lu\n", (long) sideEffects->indirect);

	if(
		((sideEffects->parentKind == pExpression) && (!sideEffects->eParent->hasSideEffects)) ||
		((sideEffects->parentKind == pStatement) && (!sideEffects->sParent->hasSideEffects)) ||
		((sideEffects->parentKind == pFun) && (!sideEffects->fParent->hasSideEffects))
	) {
		return;
	}

	if(sideEffects->direct) {
		if(sideEffects->var == NULL) {
			printf("ABSOLUTE\n");
		} else {
			printf("%s\n", sideEffects->var);
		}
	} else {
		printSideEffects(sideEffects->indirect);
	}

	if(sideEffects->rest != NULL) {
		printSideEffects(sideEffects->rest);
	}
}
