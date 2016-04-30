#include "optimizer.h"

void optimize(Funs *funs) {
    find_semantics(funs);
    remove_code(funs);
}
