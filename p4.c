#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <inttypes.h>
#include "parser.h"

/*
REFERENCES:
All from p3

Stack frames:
http://stackoverflow.com/questions/3699283/what-is-stack-frame-in-assembly
https://en.wikipedia.org/wiki/Call_stack#Structure

Calling conventions:
https://en.wikibooks.org/wiki/X86_Disassembly/Calling_Convention_Examples#CDECL_2

Debugging:
https://sourceware.org/gdb/onlinedocs/gdb/TUI-Commands.html
*/

// because macs are special...
#ifdef __APPLE__
#define PRINTF_NAME "_printf"
#define SCANF_NAME "_scanf"
#define CALLOC_NAME "_calloc"
#define MEMCPY_NAME "_memcpy"
#define MAIN_NAME "_main"
#else
#define PRINTF_NAME "printf"
#define SCANF_NAME "scanf"
#define CALLOC_NAME "calloc"
#define MEMCPY_NAME "memcpy"
#define MAIN_NAME "main"
#endif

// a list of all the global vars
Formals *globalScope = NULL;
// statement that returns 0 (added to the end of all methods)
Statement *defaultReturn = NULL;

// true if the stack is aligned to 16 bytes
// bool stackAligned = false;
// used to generate unique labels
int labelCounter = 0;

// all the functions in the program
Funs *funs;
Closures *closures;

/* finds the node with the specified item */
Formals *findNode(Formals *list, char *str) {
	Formals *current = list;
	// iterate over each node in the list
	while(current != NULL) {
		// if the node's item matches the search item, return the current node
		if(strcmp(current->first, str) == 0) {
			return current;
		}

		// advance to the next node
		current = current->rest;
	}

	return NULL;
}

Formals *addGlobalVar(char *str) {
	// try finding the variable in the list
	Formals *node = findNode(globalScope, str);
	if(node == NULL) { // if it doesn't exist, add a new node to the beginning
		// make a new node and put it on the head of the list
		Formals *new_node = calloc(1, sizeof(Formals));

		if(globalScope == NULL) {
			new_node->n = 1;
		} else {
			new_node->n = globalScope->n + 1;
		}

		new_node->first = str;
		new_node->rest = globalScope;

		globalScope = new_node;
	} else { // if it exists, return it
		return node;
	}

	return globalScope;
}

Fun *getFunByName(char *funName) {
	FOREACH(funs) if(strcmp(__item->first->name, funName) == 0) return __item->first;

	return NULL;
}

Closure *getClosureByName(char *closureName) {
	FOREACH(closures) if(strcmp(__item->first->name, closureName) == 0) return __item->first;

	return NULL;
}

void genFun(Fun *);
void genStatement(Statement *, Formals *);
void genActuals(Actuals *, Formals *);
void genLoadOperands();
void genSaveResult();
void genEvalBoolean();
void genExpression(Expression *, Formals *);

void genAssignment(Statement *, Formals *);
void genPrint(Statement *, Formals *);
void genScan(Statement *, Formals *);
void genBind(Statement *, Formals *);
void genIf(Statement *, Formals *);
void genWhile(Statement *, Formals *);
void genBlock(Statement *, Formals *);
void genReturn(Statement *, Formals *);

void genFun(Fun *function) {
	// // stack is misaligned at the beginning of a function
	// stackAligned = false;

	// create the label and save the previous base pointer
	printf("%s_fun:\n", function->name);
	printf("	push %%rbp\n");
	// stackAligned = !stackAligned;
	// set the base pointer to after existing data
	printf("	mov %%rsp, %%rbp\n");

	// generate the body and add the default return statement
	genStatement(function->body, function->formals);
	genStatement(defaultReturn, function->formals);

	printf("\n");
}

void genClosure(Closure *closure) {
	// // stack is misaligned at the beginning of a function
	// stackAligned = false;

	// // calls a fun or another closure
	// size_t funArgs = 0;
	//
	// Fun *function = getFunByName(closure->funName);
	// if(function != NULL) {
	// 	funArgs = (function->formals != NULL) ? function->formals->n : 0;
	// } else {
	// 	Closure *other = getClosureByName(closure->funName);
	// 	funArgs = other->numArgs;
	// }
	//
	// // create the label and save the previous base pointer
	// printf("%s_fun:\n", closure->name);
	// printf("	push %%rbp\n");
	// // stackAligned = !stackAligned;
	// // set the base pointer to after existing data
	// printf("	mov %%rsp, %%rbp\n");
	//
	// // calculate the alignment after pushing args
	// // bool currentAligned = stackAligned ^ (closure->numArgs & 1);
	// // if(expression->callActuals != NULL) {
	// // 	currentAligned ^= LIST_LEN(expression->callActuals) & 1;
	// // }
	//
	// // add padding if necessary
	// // if(!currentAligned) {
	// // 	printf("	sub $8, %%rsp\n");
	// // }
	//
	// // push arguments onto stack
	// // TODO: check for callee saved registers
	// size_t argsSize = (funArgs - closure->numArgs) * 8;
	//
	// // allocate space for the args
	// printf("	sub %lu, %%rsp\n", argsSize);
	//
	// // copy them using memcpy
	// printf("	lea %lu(%%rsp), %%rdi\n", argsSize);
	// printf("	lea %s_closure_data(%%rip), %%rsi\n", closure->name);
	// printf("	mov %lu, %%rdx\n", argsSize);
	//
	// // // if the stack isn't aligned, push 8 bytes
	// // if(!stackAligned) {
	// // 	printf("	sub $8, %%rsp\n");
	// // }
	//
	// // make the actual call to memcpy
	// printf("	call %s\n", MEMCPY_NAME);
	//
	// // // if we had pushed to align, pop to restore the correct stack
	// // if(!stackAligned) {
	// // 	printf("	add $8, %%rsp\n");
	// // }
	//
	// // call the function
	// printf("	call %s_fun\n", closure->funName);
	//
	// // remove the padding if we added it
	// // if(!currentAligned) {
	// // 	printf("	add $8, %%rsp\n");
	// // }
	//
	// // stackAligned = currentAligned;
	//
	// // // push return value onto stack
	// // printf("	push %%rax\n");
	// // stackAligned = !stackAligned;
	//
	// // // generate the body and add the default return statement
	// // genStatement(function->body, function->formals);
	// // genStatement(defaultReturn, function->formals);
	//
	// printf("	ret\n");
	//
	// printf("\n");

	printf("%s_fun:\n", closure->name);

	// TODO: check for callee saved registers
	size_t argsSize = closure->numArgs * 8;

	// pop the return address
	printf("	pop %%rbx\n");

	// allocate space for the arguments
	printf("	sub $%lu, %%rsp\n", argsSize);

	// copy them using memcpy
	// printf("	lea %lu(%%rsp), %%rdi\n", argsSize);
	printf("	mov %%rsp, %%rdi\n");
	printf("	lea %s_closure_data(%%rip), %%rsi\n", closure->name);
	printf("	mov $%lu, %%rdx\n", argsSize);

	// make the actual call to memcpy
	printf("	call %s\n", MEMCPY_NAME);

	// put the return address back
	printf("	push %%rbx\n");

	// jump to the function
	printf("	jmp %s_fun\n", closure->funName);

	printf("\n");
}

// void genClosureData(Closure *closure) {
// 	// TODO
// }

void genStatement(Statement *statement, Formals *scope) {
	switch(statement->kind) {
		case sAssignment: {
			genAssignment(statement, scope);
		} break;

		case sPrint: {
			genPrint(statement, scope);
		} break;

		case sScan: {
			genScan(statement, scope);
		} break;

		case sBind: {
			genBind(statement, scope);
		} break;

		case sIf: {
			genIf(statement, scope);
		} break;

		case sWhile: {
			genWhile(statement, scope);
		} break;

		case sBlock: {
			genBlock(statement, scope);
		} break;

		case sReturn: {
			genReturn(statement, scope);
		} break;
	}
}

void genActuals(Actuals *actuals, Formals *scope) {
	FOREACH(actuals) {
		genExpression(__item->first, scope);
	}
}

/* load operands for binary operations */
void genLoadOperands() {
	printf("	pop %%rcx\n");
	printf("	pop %%rax\n");
}

/* push the result onto the stack */
void genSaveResult() {
	printf("	push %%rax\n");
	// stackAligned = !stackAligned;
}

/* set the flags for a boolean value (0 = false, !0 = true) */
void genEvalBoolean() {
	printf("	pop %%rax\n");
	// stackAligned = !stackAligned;

	printf("	cmp $0, %%rax\n");
}

void genExpression(Expression *expression, Formals *scope) {
	switch(expression->kind) {
		case eVAR: {
			// very similar to sAssignment
			Formals *localVar = findNode(scope, expression->varName);

			if(localVar != NULL) {
				int offset = 16 + 8 * (scope->n - localVar->n);
				printf("	push %d(%%rbp)\n", offset);
			} else {
				Formals *globalVar = addGlobalVar(expression->varName);
				printf("	push %s_var(%%rip)\n", globalVar->first);
			}

			// stackAligned = !stackAligned;
		} break;

		case eVAL: {
			// push the immediate value onto the stack
			// printf("	push $%"PRIu64"\n", expression->val);
			printf("	push $%llu\n", expression->val);
			// stackAligned = !stackAligned;
		} break;

		case ePLUS: {
			// generate the LHS and RHS
			genExpression(expression->left, scope);
			genExpression(expression->right, scope);

			// do the addition
			genLoadOperands();
			printf("	add %%rcx, %%rax\n");
			genSaveResult();
		} break;

		case eMINUS: {
			// generate the LHS and RHS
			genExpression(expression->left, scope);
			genExpression(expression->right, scope);

			// do the addition
			genLoadOperands();
			printf("	sub %%rcx, %%rax\n");
			genSaveResult();
		} break;

		case eMUL: {
			// same as ePLUS
			genExpression(expression->left, scope);
			genExpression(expression->right, scope);

			genLoadOperands();
			printf("	mul %%rcx\n");
			genSaveResult();
		} break;

		case eDIV: {
			// same as ePLUS
			genExpression(expression->left, scope);
			genExpression(expression->right, scope);

			genLoadOperands();
			printf("	mov $0, %%rdx\n");
			printf("	div %%rcx\n");
			genSaveResult();
		} break;

		case eEQ: {
			// similar to ePLUS
			genExpression(expression->left, scope);
			genExpression(expression->right, scope);

			genLoadOperands();
			// compare the operands and push 0 if false, and 1 if true
			printf("	cmp %%rax, %%rcx\n");
			printf("	mov $0, %%rax\n");
			printf("	sete %%al\n");
			genSaveResult();
		} break;

		case eNE: {
			// same as eEQ
			genExpression(expression->left, scope);
			genExpression(expression->right, scope);

			genLoadOperands();
			printf("	cmp %%rax, %%rcx\n");
			printf("	mov $0, %%rax\n");
			printf("	setne %%al\n");
			genSaveResult();
		} break;

		case eLT: {
			// same as eEQ
			genExpression(expression->right, scope);
			genExpression(expression->left, scope);

			genLoadOperands();
			printf("	cmp %%rax, %%rcx\n");
			printf("	mov $0, %%rax\n");
			printf("	setb %%al\n");
			genSaveResult();
		} break;

		case eGT: {
			// same as eEQ
			genExpression(expression->right, scope);
			genExpression(expression->left, scope);

			genLoadOperands();
			printf("	cmp %%rax, %%rcx\n");
			printf("	mov $0, %%rax\n");
			printf("	seta %%al\n");
			genSaveResult();
		} break;

		case eCALL: {
			// calculate the alignment after pushing args
			// bool currentAligned = stackAligned;
			// if(expression->callActuals != NULL) {
			// 	currentAligned ^= LIST_LEN(expression->callActuals) & 1;
			// }

			// add padding if necessary
			// if(!currentAligned) {
			// 	printf("	sub $8, %%rsp\n");
			// }

			// push arguments onto stack
			genActuals(expression->callActuals, scope);

			// call the function
			printf("	call %s_fun\n", expression->callName);

			// remove the padding if we added it
			// if(!currentAligned) {
			// 	printf("	add $8, %%rsp\n");
			// }

			// stackAligned = currentAligned;

			// push return value onto stack
			printf("	push %%rax\n");
			// stackAligned = !stackAligned;
		} break;
	}
}

void genAssignment(Statement *statement, Formals *scope) {
	// see if a local var with that name exists
	Formals *localVar = findNode(scope, statement->assignName);

	// generate the RHS and load it into %rax
	genExpression(statement->assignValue, scope);
	printf("	pop %%rax\n");
	// stackAligned = !stackAligned;

	if(localVar != NULL) { // if there is a local var, set that
		int offset = 16 + 8 * (scope->n - localVar->n);
		printf("	mov %%rax, %d(%%rbp)\n", offset);
	} else { // otherwise, set the global one
		Formals *globalVar = addGlobalVar(statement->assignName);
		printf("	mov %%rax, %s_var(%%rip)\n", globalVar->first);
	}
}

void genPrint(Statement *statement, Formals *scope) {
	// generate the value being printed
	genExpression(statement->printValue, scope);

	// load the arguments for printf
	printf("	lea printf_format(%%rip), %%rdi\n");
	printf("	pop %%rsi\n");
	// stackAligned = !stackAligned;

	// if the stack isn't aligned, push 8 bytes
	// if(!stackAligned) {
	// 	printf("	sub $8, %%rsp\n");
	// }

	// make the actual call to printf
	printf("	mov $0, %%rax\n");
	printf("	call %s\n", PRINTF_NAME);

	// if we had pushed to align, pop to restore the correct stack
	// if(!stackAligned) {
	// 	printf("	add $8, %%rsp\n");
	// }
}

void genScan(Statement *statement, Formals *scope) {
	// generate the value being printed
	// genExpression(statement->printValue, scope);

	// load the arguments for scanf
	printf("	lea scanf_format(%%rip), %%rdi\n");
	// printf("	pop %%rsi\n");
	// stackAligned = !stackAligned;

	// see if a local var with that name exists
	Formals *localVar = findNode(scope, statement->scanVar);

	if(localVar != NULL) { // if there is a local var, get its address
		int offset = 16 + 8 * (scope->n - localVar->n);
		printf("	lea %d(%%rbp), %%rsi\n", offset);
	} else { // otherwise, use the global one's address
		Formals *globalVar = addGlobalVar(statement->scanVar);
		printf("	lea %s_var(%%rip), %%rsi\n", globalVar->first);
	}

	// if the stack isn't aligned, push 8 bytes
	// if(!stackAligned) {
	// 	printf("	sub $8, %%rsp\n");
	// }

	// make the actual call to scanf
	printf("	mov $0, %%rax\n");
	printf("	call %s\n", SCANF_NAME);

	// if we had pushed to align, pop to restore the correct stack
	// if(!stackAligned) {
	// 	printf("	add $8, %%rsp\n");
	// }
}

void genBind(Statement *statement, Formals *scope) {
	// bool argsAligned = stackAligned;

	// push arguments onto stack
	size_t numArgs = LIST_LEN(statement->closureActuals);
	size_t argsSize = numArgs * 8;
	genActuals(statement->closureActuals, scope);

	// TODO: check for callee saved registers
	// load the arguments for memcpy
	printf("	lea %s_closure_data(%%rip), %%rdi\n", statement->closure->name);
	// printf("	lea %lu(%%rsp), %%rsi\n", argsSize);
	printf("	mov %%rsp, %%rsi\n");
	printf("	mov $%lu, %%rdx\n", argsSize);

	// // if the stack isn't aligned, push 8 bytes
	// if(!stackAligned) {
	// 	printf("	sub $8, %%rsp\n");
	// }

	// make the actual call to memcpy
	printf("	call %s\n", MEMCPY_NAME);

	// // if we had pushed to align, pop to restore the correct stack
	// if(!stackAligned) {
	// 	printf("	add $8, %%rsp\n");
	// }

	// remove the closure args from the stack
	printf("	add $%lu, %%rsp\n", argsSize);
	// stackAligned = argsAligned;

	STACK_PUSH(&closures, statement->closure);
}

void genIf(Statement *statement, Formals *scope) {
	int labelNum = labelCounter++;

	// generate the condition and set flags accordingly
	genExpression(statement->ifCondition, scope);
	genEvalBoolean();

	// bool currentAligned = stackAligned;
	// if false, go to the else part
	printf("	je else_%d\n", labelNum);

	// if true, continue to the then part
	genStatement(statement->ifThen, scope);
	// after running the then part, skip the else
	printf("	jmp after_%d\n", labelNum);

	// stackAligned = currentAligned;
	// generate the else part, if there is one
	printf("	else_%d:\n", labelNum);
	if(statement->ifElse != NULL) {
		genStatement(statement->ifElse, scope);
	}

	// put the after label after the whole construct
	// stackAligned = currentAligned;
	printf("	after_%d:\n", labelNum);
}

void genWhile(Statement *statement, Formals *scope) {
	int labelNum = labelCounter++;
	// label the beginning of the loop
	printf("	loop_%d:\n", labelNum);

	// generate the condition and set flags accordingly
	genExpression(statement->whileCondition, scope);
	genEvalBoolean();

	// if false, skip the loop body
	printf("	je after%d\n", labelNum);

	genStatement(statement->whileBody, scope);
	// go back to the beginning
	printf("	jmp loop_%d\n", labelNum);
	// put the after label after the whole construct
	printf("	after%d:\n", labelNum);
}

void genBlock(Statement *statement, Formals *scope) {
	// generate all the statements in the block
	FOREACH(statement->block) genStatement(__item->first, scope);
}

void genReturn(Statement *statement, Formals *scope) {
	// generate the value being returned and put it into %rax
	genExpression(statement->returnValue, scope);
	printf("	pop %%rax\n");
	// stackAligned = !stackAligned;

	// reset the stack pointers
	printf("	mov %%rbp, %%rsp\n");
	printf("	pop %%rbp\n");
	// stackAligned = !stackAligned;

	printf("	ret\n");
}

int main(int argc, char *argv[]) {
	// set up the default return statement
	defaultReturn = calloc(1, sizeof(Statement));
	defaultReturn->kind = sReturn;

	defaultReturn->returnValue = calloc(1, sizeof(Expression));
	defaultReturn->returnValue->kind = eVAL;
	defaultReturn->returnValue->val = 0;

	// parse the code
	funs = parse();
	// Funs *p = parse();

	// begin the .text section (code)
	printf(".text\n");
	// make main accessible from other files
	printf("	.global %s\n", MAIN_NAME);

	// declare printf
	printf("	.extern %s\n", PRINTF_NAME);
	printf("	.extern %s\n", SCANF_NAME);
	printf("	.extern %s\n", MEMCPY_NAME);
	printf("\n");

	// generate the program entry point
	printf("%s:\n", MAIN_NAME);
	printf("	jmp main_fun\n");
	printf("\n");

	// generate all the function
	FOREACH(funs) genFun(__item->first);
	FOREACH(closures) genClosure(__item->first);

	// begin the .data section (variables)
	printf(".data\n");
	// the format string to print variables on assignment
	printf("printf_format: .string \"%%d\\n\"\n");
	printf("scanf_format: .string \"%%d\"\n");

	// generate allocations for all global vars and their names
	FOREACH(globalScope) {
		printf("%s_var: .quad 0\n", __item->first);
		// printf("	%1$s_name: .string \"%1$s\"\n", __item->first);
	}

	// generate allocations for all closure data
	// FOREACH(closures) genClosureData(__item->first);
	FOREACH(closures) {
		printf("%s_closure_data: .zero %lu\n", __item->first->name, __item->first->numArgs * 8);
	}

	return 0;
}
