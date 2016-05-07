#include <stdlib.h>
#include <stdio.h>

#include "optimizer.h"
#include "parser.h"

#include <stdbool.h>
#include <string.h>
#include <inttypes.h>


void assign_expression(Vars *depends, Expression *expression);
void handle_statement(Statement *statement, Vars *legacy);

// void add_var(Vars **list, Var v) {
// 	Vars *new_node = NEW(Vars);
// 	new_node->first = v;
// 	new_node->rest = *list;
//
// 	*list = new_node;
// }

bool contains_var(Vars *list, Var *v) {
	FOREACH(list) {
		if(strcmp(__item->first->name, v->name) == 0) {
			return true;
		}
	}

	return false;
}

void add_legacy(Vars **depends, Vars *legacy) {
	FOREACH(legacy) {
		STACK_PUSH(depends, __item->first);
	}
}

void add_expression(Vars **depends, Expression *assignValue) {
	switch(assignValue->kind) {
		case eVAR : {
			Var *v = NEW(Var);
			v->name = assignValue->varName;
			v->local = 0; //for now
			STACK_PUSH(depends, v);
		} break;
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
		} break;

		case eVAL : {
			return;
		} break;

		default : {
			printf("not implemented something in add_expression\n");
			exit(1);
		}
	}
}

void remove_var(Vars **legacy) {
    *legacy = (*legacy)->rest;
}

void remove_expression(Vars **legacy, Expression *expression) {
    switch(expression->kind) {
        case eVAR : {
            remove_var(legacy);
        } break;
        case ePLUS :
        case eMINUS :
        case eMUL :
        case eDIV :
        case eEQ :
        case eNE :
        case eLT :
        case eGT : {
            remove_expression(legacy, expression->left);
            remove_expression(legacy, expression->right);
        } break;

        case eVAL : {
            return;
        } break;

        default : {
            printf("not implemented something in add_expression\n");
            exit(1);
        }
    }
}

void assignDepends(Vars **depends, Expression *assignValue, Vars *legacy) {
	add_legacy(depends, legacy);
	add_expression(depends, assignValue);
}

void handle_assignment(Statement *statement, Vars *legacy) {
	statement->semantics->modifies = NEW(Vars);
	Var *v = NEW(Var);
	v->name = statement->assignName;
	statement->semantics->modifies->first = v;
	assignDepends(&statement->semantics->depends, statement->assignValue, legacy);
}

void handle_print(Statement *statement, Vars *legacy) {
	assignDepends(&statement->semantics->depends, statement->printValue, legacy);
	statement->semantics->anchor = true;
}

void handle_scan(Statement *statement, Vars *legacy) {
	statement->semantics->modifies->first->name = statement->scanVar;
	statement->semantics->anchor = true;
}

void handle_if(Statement *statement, Vars *legacy) {
    add_expression(&legacy, statement->ifCondition);
    if(statement->ifThen != NULL) handle_statement(statement->ifThen, legacy);
    printf("The ifelse is %d", (int)(statement->ifElse));
    if(statement->ifElse != NULL) handle_statement(statement->ifElse, legacy);
    remove_expression(&legacy, statement->ifCondition);
}

void handle_while(Statement *statement, Vars *legacy) {
	add_expression(&legacy, statement->whileCondition);
    handle_statement(statement->whileBody, legacy);
    remove_expression(&legacy, statement->whileCondition);
}

void handle_block(Statement *statement, Vars *legacy) {
	Block *block = statement->block;
	FOREACH(block) {
		handle_statement(__item->first, legacy);
	}
}

void handle_return(Statement *statement, Vars *legacy) {
	printf("not implemented everything yet return\n");
	exit(1);
}



void handle_statement(Statement *statement, Vars *legacy) {
	if(statement->semantics == NULL) {
		statement->semantics = NEW(Semantics);
	}

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
		} break;
		case sNull :
	}
}

void find_semantics(Funs *funs, Vars *legacy) {
	// Fun function;
	FOREACH(funs) {
		handle_statement(__item->first->body, legacy);
	}
}

void mark_needed(Vars *vars, Statements *statements) {
	// recursively mark statements to keep
	while(vars != NULL) {
		Var *v = STACK_POP(&vars);
		printf("%s\n", v->name);

		// go through all previous statements
		FOREACH(statements) {
			// if it modifies a required var, mark all of its dependencies
			if(contains_var(__item->first->semantics->modifies, v)) {
				__item->first->needed = true;
				mark_needed(__item->first->semantics->depends, __item);
			}
		}
	}
}

void remove_assignment(Statements *statement, Vars *var_used, Vars *var_legacy) {
	
}

void remove_code_statement(Statement statement, Vars *var_used, Vars *var_legacy) {
	switch(body->kind) {
		case : sAssignment {
			remove_assignment(statement, var_used, var_legacy);
		} break;
    	case : sPrint {
    		remove_print(statement, var_used, var_legacy);
    	} break;
    	case : sScan {
    		remove_scan(statement, var_used, var_legacy);

    	} break;
    	case : sBind {
    		remove_bind(statement, var_used, var_legacy);

    	} break;
    	case : sIf {
    		remove_if(statement, var_used, var_legacy);

    	} break;
    	case : sWhile {
    		remove_while(statement, var_used, var_legacy);

    	} break;
    	case : sBlock {
    		remove_block(statement, var_used, var_legacy);

    	} break;
    	case : sReturn {
    		remove_return(statement, var_used, var_legacy);

    	} break;
    	case : sNull {

    	}

	}
}

void remove_code_function(Fun *fun) {
	Vars *var_used = NEW(Vars);
	Vars *var_legacy = NEW(Vars);
	Statement body = fun->body;
	remove_code_statement(fun->body, var_set, var_legacy);
	free(var_used);
	free(var_legacy)
}

void remove_code(Funs *funs) {
	FOREACH(funs) {
		remove_code_function(__item->first);
	}
}

void optimize(Funs *funs) {
	find_semantics(funs, NULL);
	remove_code(funs);
}

void print_vars(Vars *v) {
	if(v == NULL) {
		printf("\tNONE\n");
	}

	FOREACH(v) {
		if(v->first->local) printf("\t%s is local\n", __item->first->name);
		else printf("\t%s is not local\n", __item->first->name);
	}
}

void print_statement_semantics(Statement *s) {
	// Statement *tempStatement;
	Block *tempBlock;

		switch (s->kind) {
			case sBlock : {
				printf("ENTERING BLOCK\n");
				tempBlock = s->block;
				FOREACH(tempBlock) {
					print_statement_semantics(__item->first);
				}
			} break;
			case sIf : {
				printf("ENTERING IF\n");
				printf("ENTERING IFTHEN\n");
				if(s->ifThen != NULL) print_statement_semantics(s->ifThen);
				printf("ENTERING IFELSE\n");
                if(s->ifElse != NULL) print_statement_semantics(s->ifElse);
			} break;
			case sWhile : {
				printf("ENTERING WHILE\n");
				print_statement_semantics(s->whileBody);
			} break;
			case sNull : break;
			default : {
			printf("printing mods\n");
			print_vars(s->semantics->modifies);
			printf("printing depends\n");
			print_vars(s->semantics->depends);
			if(s->semantics->anchor) printf("Is an anchor\n");
			if(s->needed) printf("Is needed\n");
			printf("\n");
			}
		}


}

void print_func_semantics(Fun *f) {
	printf("PRINTING DEPENDENCIES FOR %s\n", f->name);
	print_statement_semantics(f->body);
}

void print_semantics(Funs *funs) {
	FOREACH(funs) {
		print_func_semantics(__item->first);
	}
}

int main(int argc, char *argv[]) {

	// parse the code
	Funs *p = parse();
	// find_semantics(p, NULL);
	optimize(p);
	print_semantics(p);

}
