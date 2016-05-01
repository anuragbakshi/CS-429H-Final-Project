#include <stdlib.h>
#include <stdio.h>

#include "optimizer.h"
#include "parser.h"

#include <stdbool.h>
#include <string.h>
#include <inttypes.h>


void assign_expression(Vars *depends, Expression *expression);
void handle_statement(Statement *statement, Vars *legacy);

void add_var(Vars **list, Var v) {
    Vars *new_node = NEW(Vars);
    new_node->first = v;
    new_node->rest = *list;

    *list = new_node;
}

void add_legacy(Vars *depends, Vars *legacy) {
    while(legacy != NULL) {
        add_var(&depends, legacy->first);
        legacy = legacy->rest;
    }
}

void add_expression(Vars *depends, Expression *assignValue) {
    switch(assignValue->kind) {
        case eVAR : {
            Var *v = NEW(Var);
            v->name = assignValue->varName;
            v->local = 0; //for now
            add_var(&depends, *v);
        }
        case ePLUS :
        case eMINUS :
        case eMUL :
        case eDIV :
        case eEQ :
        case eNE :
        case eLT :
        case eGT : {
            add_expression(depends, assignValue->left);
            add_expression(depends, assignValue->right);
        }
        default : {
            printf("not implemented something in add_expression\n");
            exit(1);
        }
    }
}

void assignDepends(Vars *depends, Expression *assignValue, Vars *legacy) {
    add_legacy(depends, legacy);
    add_expression(depends, assignValue);
}

void handle_assignment(Statement *statement, Vars *legacy) {
    statement->semantics->modifies = NEW(Vars);
    Var *v = NEW(Var);
    v->name = statement->assignName;
    statement->semantics->modifies->first = *v;
    assignDepends(statement->semantics->depends, statement->assignValue, legacy);
}

void handle_print(Statement *statement, Vars *legacy) {
    assignDepends(statement->semantics->depends, statement->assignValue, legacy);
    statement->semantics->anchor = true;
}

void handle_scan(Statement *statement, Vars *legacy) {
    statement->semantics->modifies->first.name = statement->scanVar;
    assignDepends(statement->semantics->depends, statement->assignValue, legacy);
    statement->semantics->anchor = true;
}

void handle_if(Statement *statement, Vars *legacy) {
    printf("not implemented everything yet if\n");
    exit(1);
}

void handle_while(Statement *statement, Vars *legacy) {
    printf("not implemented everything yet while\n");
    exit(1);
}

void handle_block(Statement *statement, Vars *legacy) {
    Block *block = statement->block;
    while(block != NULL) {
        handle_statement(block->first, legacy);
        block = block->rest;
    }
}

void handle_return(Statement *statement, Vars *legacy) {
    printf("not implemented everything yet return\n");
    exit(1);
}



void handle_statement(Statement *statement, Vars *legacy) {
    Semantics *semantics = statement->semantics;
    semantics->modifies = NEW(Vars);
    semantics->modifies->first.local = false; // for now
    switch(statement->kind) {
        case sAssignment : {
            handle_assignment(statement, legacy);
        } break;
        case sPrint : {
            handle_print(statement, legacy);
        } break;
        case sScan : {
            handle_scan(statement, legacy);
        } break;
        case sIf :{
            handle_if(statement, legacy);
        } break;
        case  sWhile : {
            handle_while(statement, legacy);
        } break;
        case sBlock : {
            handle_block(statement, legacy);
        } break;
        case sReturn : {
            handle_return(statement, legacy);
        }
    }
}

void find_semantics(Funs *funs, Vars *legacy) {
    Fun function;
    while(funs != 0) {
        handle_statement(funs->first->body, legacy);
        funs = funs->rest;
    }
}

void remove_code(Funs *funs) {

}

void optimize(Funs *funs) {
    find_semantics(funs, NEW(Vars));
    remove_code(funs);
}

void print_vars(Vars *v) {
    while(v != NULL) {
        if(v->first.local) printf("%s is local\n", v->first.name);
        else printf("%s is not local\n", v->first.name);
    }
}

void print_statement_semantics(Statement *s) {
    Statement *tempStatement;
    Block *tempBlock;
    while(s != NULL) {
        switch (s->kind) {
            case sBlock : {
                printf("ENTERING BLOCK\n");
                tempBlock = s->block;
                while(tempBlock != NULL) {
                    print_statement_semantics(tempBlock->first);
                    tempBlock = tempBlock->rest;
                }
            } break;
            case sIf : {
                printf("ENTERING IF\n");
                printf("ENTERING IFTHEN\n");
                print_statement_semantics(s->ifThen);
                printf("ENTERING IFELSE\n");
                print_statement_semantics(s->ifElse);
            } break;
            case sWhile : {
                printf("ENTERING WHILE\n");
                print_statement_semantics(s->whileBody);
            } break;
            default : {
            print_vars(s->semantics->modifies);
            print_vars(s->semantics->depends);
            if(s->semantics->anchor) printf("Is an anchor\n");
            }
        }
    }
    
}

void print_func_semantics(Fun *f) {
    printf("PRINTING DEPENDANCIES FOR %s\n", f->name);
    print_statement_semantics(f->body);
}

void print_semantics(Funs *funs) {
    while(funs != NULL) {
        print_func_semantics(funs->first);
        funs = funs->rest;
    }
}

int main(int argc, char *argv[]) {

    // parse the code
    Funs *p = parse();

    find_semantics(p, NEW(Vars));

    print_semantics(p);

    }

