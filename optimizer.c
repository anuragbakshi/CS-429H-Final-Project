#include <stdlib.h>
#include <stdio.h>

#include "optimizer.h"
#include "parser.h"

#include <stdbool.h>
#include <string.h>

#define PRINTF_NAME "printf"
#define SCANF_NAME "scanf"
// #define CALLOC_NAME "calloc"
#define MEMCPY_NAME "memcpy"
#define PCREATE_NAME "pthread_create"
#define PJOIN_NAME "pthread_join"
#define MAIN_NAME "main"


void set_add(Expression *expression, Vars *vars_used);

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
		} default : break;
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



void set_add_one_var(Var *v, Vars *vars) {
	if(vars->first == NULL) {
		vars->first = v;
		return;
	}
	while(vars != NULL) {
		if(strcmp(vars->first->name, v->name) == 0) return;
		if(vars->rest == NULL) {
			Vars *newVars = NEW(Vars);
			newVars->first = v;
			vars->rest = newVars;
			return;
		}
		vars = vars->rest;
	}
}

void get_vars(Expression *expression, Vars *vars) {
	if(expression == NULL || vars == NULL) return; //DEBUGGING
	Vars *temp;
	switch(expression->kind) {
		case eVAR : {
			Var *v = NEW(Var);
			v->name = expression->varName;
			set_add_one_var(v, vars);
		}
		case ePLUS:
		case eMINUS:
		case eMUL:
		case eDIV:
		case eEQ:
		case eNE:
		case eLT:
		case eGT: {
			get_vars(expression->left, vars);
			get_vars(expression->right, vars);
		} break;
		default : break;
	}
}

void only_add_bodyvars(Statement *statement, Vars *vars_used) {
	switch(statement->kind) {

		case sAssignment : {
			set_add(statement->assignValue, vars_used);
		} break;
		case sPrint : {
			set_add(statement->printValue, vars_used);
		} break;
		case sIf : {
			set_add(statement->ifCondition, vars_used);
			if(statement->ifThen != NULL) only_add_bodyvars(statement->ifThen, vars_used);
			if(statement->ifElse != NULL) only_add_bodyvars(statement->ifElse, vars_used);
		} break;
		case sWhile : {
			set_add(statement->whileCondition, vars_used);
			if(statement->whileBody != NULL) only_add_bodyvars(statement->whileBody, vars_used);
		} break;

		case sBlock : {
			Block *block = statement->block;
			while(block != NULL) {
				only_add_bodyvars(block->first, vars_used);
				block = block->rest;
			}
		} break;
		case sReturn : {
			set_add(statement->returnValue, vars_used);
		} break;
		default : break;
	}
} //todo

void remove_from_set(char *varName, Vars **var_set) {
	if((*var_set)->first == NULL) return;
	if(strcmp((*var_set)->first->name, varName) == 0) {
		if((*var_set)->rest == NULL) *var_set = NEW(Vars);
		else *var_set = (*var_set)->rest;
		return;
	}
	Vars *temp = *var_set;
	Vars *temp2 = (*var_set)->rest;
	while(temp2 != NULL) {
		if(strcmp(temp2->first->name, varName) == 0) {
			temp->rest = temp2->rest;
			free(temp2);
			return;
		}
		temp = temp2;
		temp2 = temp2->rest;
	}
}

int in_set(char *varName, Vars *var_set) {
	if(var_set->first == NULL) return 0;
	while(var_set != NULL) {
		if(strcmp(var_set->first->name, varName) == 0) return 1;
		var_set = var_set->rest;
	}
	return 0;
}

void set_add(Expression *expression, Vars *vars_used) {
	Vars *list_of_vars = NEW(Vars);
	get_vars(expression, list_of_vars);
	while(list_of_vars != NULL && list_of_vars->first != NULL) {
		set_add_one_var(list_of_vars->first, vars_used);
		list_of_vars = list_of_vars->rest;
	}
	if(list_of_vars != NULL) free(list_of_vars);
}

void remove_return(Statement *statement, Vars *vars_used) {
	set_add(statement->returnValue, vars_used);
}

void remove_while(Statement *statement, Vars *vars_used) {
	set_add(statement->whileCondition, vars_used);
	if(statement->whileBody != NULL) only_add_bodyvars(statement->whileBody, vars_used);
}

void remove_if(Statement *statement, Vars *vars_used) {
	set_add(statement->ifCondition, vars_used);
	if(statement->ifThen != NULL) only_add_bodyvars(statement->ifThen, vars_used); //todo
	if(statement->ifElse != NULL) only_add_bodyvars(statement->ifElse, vars_used);
}

void remove_code_statement(Statement *statement, Vars *vars_used);

void remove_block(Block *block, Vars *vars_used) {
	if(block == NULL) return;
	remove_block(block->rest, vars_used);
	remove_code_statement(block->first, vars_used);
}

void remove_scan(Statement *statement, Vars *vars_used) {
	if(in_set(statement->scanVar, vars_used)) remove_from_set(statement->scanVar, &vars_used); 
	else statement->kind = sNull; 
}

void remove_assignment(Statement *statement, Vars *vars_used) {
	if(in_set(statement->assignName, vars_used)) {
		remove_from_set(statement->assignName, &vars_used);
		set_add(statement->assignValue, vars_used);
	}
	else statement->kind = sNull;
}

void remove_print(Statement *statement, Vars *vars_used) {
	set_add(statement->printValue, vars_used);
}

void remove_code_statement(Statement *statement, Vars *vars_used) {
	switch(statement->kind) {
		case sAssignment : {
			remove_assignment(statement, vars_used);
		} break;
    	case sPrint : {
    		remove_print(statement, vars_used);
    	} break;
    	case  sScan : {
    		remove_scan(statement, vars_used);
    	} break;
    	case  sIf : {
    		remove_if(statement, vars_used);

    	} break;
    	case  sWhile : {
    		remove_while(statement, vars_used);

    	} break;
    	case  sBlock : {
    		remove_block(statement->block, vars_used);

    	} break;
    	case  sReturn : {
    		remove_return(statement, vars_used);
    	} break;
    	default : break;

	}
}

void remove_code_function(Fun *fun) {
	Vars *vars_used = NEW(Vars);
	remove_code_statement(fun->body, vars_used);
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
	gen_code(p);

}
