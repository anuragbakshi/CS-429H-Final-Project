#include <stdlib.h>
#include <stdio.h>

#include "optimizer.h"
#include "parser.h"

#define NULL 0

void add_var(Vars **list, Var v) {
	Vars *new_node = NEW(Vars);
	new_node->var = v;
	new_node->next = *list;

	*list = new_node;
}

void assignModifies(Vars depends, assignValue, legacy) {
	
}

void handle_assignment(Statement *statement, Vars *legacy) {
	statement->semantics->modifies->name = statement->assignName;
	assignModifies(statement->semantics->depends, statement->assignValue, legacy);
}

void handle_print(Statement *statement, Vars *legacy) {
	printf("not implemented everything yet print\n");
	exit(1);
}

void handle_scan(Statement *statement, Vars *legacy) {
	printf("not implemented everything yet scan\n");
	exit(1);
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
