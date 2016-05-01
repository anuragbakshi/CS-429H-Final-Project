#include "optimizer.h"
#include "parser.h"

void handle_assignment(statement) {
	printf("not implemented everything yet assignment\n");	
}

void handle_print(statement) {
	printf("not implemented everything yet print\n");	
}

void handle_scan(statement) {
	printf("not implemented everything yet scan\n");	
}

void handle_if(statement) {
	printf("not implemented everything yet if\n");	
}

void handle_while(statement) {
	printf("not implemented everything yet while\n");	
}

void handle_block(statement) {
	printf("not implemented everything yet block\n");	
}

void handle_return(statement) {
	printf("not implemented everything yet return\n");	
}



void handle_statement(Statement *statement) {
	switch(statement->kind) {
		case sAssignment : {
			handle_assignment(statement);
		} break;
		case sPrint : {
			handle_print(statement);
		} break;
		case sScan(statement) : {
			handle_scan(statement);
		} break;
		case : {
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

void optimize(Funs *funs) {
    find_semantics(funs);
    remove_code(funs);
}
