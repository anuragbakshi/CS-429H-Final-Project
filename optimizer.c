#include "optimizer.h"
#include "parser.h"
void find_semantics(Funs *funs) {
	Fun function;
	while(funs != 0) {
		function = funs.first;
	}
}

void optimize(Funs *funs) {
    find_semantics(funs);
    remove_code(funs);
}
