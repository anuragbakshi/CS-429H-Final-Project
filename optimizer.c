#include <stdlib.h>
#include <stdio.h>

#include "optimizer.h"
#include "parser.h"

void add_var(Vars **list, Var v) {
    Vars *new_node = NEW(Vars);
    new_node->var = v;
    new_node->next = *list;

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
        case eVar : {
            add_var(&depends, assignValue->varName);
        }
        case ePLUS :
        case eMINUS :
        case eMUL :
        case eDIV :
        case eEQ :
        case eNE :
        case eLT :
        case eGT : {
            assign_expression(depends, assignValue->left);
            assign_expression(depends, assignValue->right);
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
    statement->semantics->modifies->name = statement->assignName;
    assignDepends(statement->semantics->depends, statement->assignValue, legacy);
}

void handle_print(Statement *statement, Vars *legacy) {
    assignModifies(statement->semantics->depends, statement->assignValue, legacy);
    statement->semantics->anchor = true;
}

void handle_scan(Statement *statement, Vars *legacy) {
    Semantics semantics = statement->semantics;
    semantics->modifies->var.name = statement->scanVar;
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
    Block block = statement->block;
    while(block != NULL) {
        handle_statement(block->first);
        block = block->rest;
    }
}

void handle_return(Statement *statement) {
    printf("not implemented everything yet return\n");
    exit(1);
}



void handle_statement(Statement *statement) {
    semantics->modifies = NEW(Vars);
    semantics->modifies->var.local = false; // for now
    switch(statement->kind) {
        case sAssignment : {
            handle_assignment(statement);
        } break;
        case sPrint : {
            handle_print(statement);
        } break;
        case sScan : {
            handle_scan(statement);
        } break;
        case sIf :{
            handle_if(statement);
        } break;
        case  sWhile : {
            handle_while(statement);
        } break;
        case sBlock : {
            handle_block(statement);
        } break;
        case sReturn : {
            handle_return(statement);
        }
    }
}

void find_semantics(Funs *funs) {
    Fun function;
    while(funs != 0) {
        handle_statement(funs->first->body);
        funs = funs->rest;
    }
}

void remove_code(Funs *funs) {

}

void optimize(Funs *funs) {
    find_semantics(funs);
    remove_code(funs);
}
