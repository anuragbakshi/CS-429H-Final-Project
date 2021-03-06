#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <inttypes.h>
#include "parser.h"
#include "optimizer.h"

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
// #ifdef __APPLE__
// #define PRINTF_NAME "_printf"
// #define SCANF_NAME "_scanf"
// #define CALLOC_NAME "_calloc"
// #define MEMCPY_NAME "_memcpy"
// #define MAIN_NAME "_main"
// #else
#define PRINTF_NAME "printf"
#define SCANF_NAME "scanf"
// #define CALLOC_NAME "calloc"
#define MEMCPY_NAME "memcpy"
#define PCREATE_NAME "pthread_create"
#define PJOIN_NAME "pthread_join"
#define MAIN_NAME "main"
// #endif

// a list of all the global vars
Formals *globalScope = NULL;
// statement that returns 0 (added to the end of all methods)
Statement *defaultReturn = NULL;

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
void genAsync(Statement *, Formals *);
void genAwait(Statement *, Formals *);
void genIf(Statement *, Formals *);
void genWhile(Statement *, Formals *);
void genBlock(Statement *, Formals *);
void genReturn(Statement *, Formals *);

void genFun(Fun *function) {
	// create the label and save the previous base pointer
	printf("%s_fun:\n", function->name);
	printf("	push %%rbp\n");

	// set the base pointer to after existing data
	printf("	mov %%rsp, %%rbp\n");

	// generate the body and add the default return statement
	genStatement(function->body, function->formals);
	genStatement(defaultReturn, function->formals);

	printf("\n");
}

void genClosure(Closure *closure) {
	printf("%s_fun:\n", closure->name);

	// TODO: check for callee saved registers
	size_t argsSize = closure->numArgs * 8;

	// pop the return address
	// printf("	pop %%rbx\n");
	// printf("	xchg %%rbx, (%%rsp)\n");

	// get the return address
	printf("	pop %%rax\n");

	// allocate space for the arguments
	printf("	sub $%lu, %%rsp\n", argsSize);

	// put the return address back
	// printf("	mov %%rax, %lu(%%rsp)\n", argsSize);
	printf("	push %%rax\n");

	// copy them using memcpy
	// printf("	lea %lu(%%rsp), %%rdi\n", argsSize);
	// printf("	mov %%rsp, %%rdi\n");
	printf("	lea 8(%%rsp), %%rdi\n");
	printf("	lea %s_closure_data(%%rip), %%rsi\n", closure->name);
	printf("	mov $%lu, %%rdx\n", argsSize);

	// make the actual call to memcpy
	printf("	call %s\n", MEMCPY_NAME);

	// put the return address back
	// printf("	push %%rbx\n");
	// printf("	xchg %%rbx, (%%rsp)\n");

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

		case sAsync: {
			genAsync(statement, scope);
		} break;

		case sAwait: {
			genAwait(statement, scope);
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
		default : break;
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
}

/* set the flags for a boolean value (0 = false, !0 = true) */
void genEvalBoolean() {
	printf("	pop %%rax\n");
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
		} break;

		case eVAL: {
			// push the immediate value onto the stack
			printf("	push $%llu\n", expression->val);
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
			Fun *fun = getFunByName(expression->callName);
			if(fun != NULL) {
				size_t numArgs = (fun->formals != NULL) ? fun->formals->n : 0;
				LIST_TRUNC(&expression->callActuals, numArgs);
			}

			// push arguments onto stack
			genActuals(expression->callActuals, scope);

			// call the function
			printf("	call %s_fun\n", expression->callName);

			// push return value onto stack
			printf("	push %%rax\n");
		} break;
	}
}

void genAssignment(Statement *statement, Formals *scope) {
	// see if a local var with that name exists
	Formals *localVar = findNode(scope, statement->assignName);

	// generate the RHS and load it into %rax
	genExpression(statement->assignValue, scope);
	printf("	pop %%rax\n");

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

	// make the actual call to printf
	printf("	mov $0, %%rax\n");
	printf("	call %s\n", PRINTF_NAME);
}

void genScan(Statement *statement, Formals *scope) {
	// load the arguments for scanf
	printf("	lea scanf_format(%%rip), %%rdi\n");

	// see if a local var with that name exists
	Formals *localVar = findNode(scope, statement->scanVar);

	if(localVar != NULL) { // if there is a local var, get its address
		int offset = 16 + 8 * (scope->n - localVar->n);
		printf("	lea %d(%%rbp), %%rsi\n", offset);
	} else { // otherwise, use the global one's address
		Formals *globalVar = addGlobalVar(statement->scanVar);
		printf("	lea %s_var(%%rip), %%rsi\n", globalVar->first);
	}

	// make the actual call to scanf
	printf("	mov $0, %%rax\n");
	printf("	call %s\n", SCANF_NAME);
}

void genBind(Statement *statement, Formals *scope) {
	// push arguments onto stack
	size_t numArgs = LIST_LEN(statement->closureActuals);
	size_t argsSize = numArgs * 8;
	genActuals(statement->closureActuals, scope);

	// load the arguments for memcpy
	printf("	lea %s_closure_data(%%rip), %%rdi\n", statement->closure->name);
	printf("	mov %%rsp, %%rsi\n");
	printf("	mov $%lu, %%rdx\n", argsSize);

	// make the actual call to memcpy
	printf("	call %s\n", MEMCPY_NAME);

	// remove the closure args from the stack
	printf("	add $%lu, %%rsp\n", argsSize);

	STACK_PUSH(&closures, statement->closure);
}

void genAsync(Statement *statement, Formals *scope) {
	// load the arguments for pthread_create
	// see if a local var with that name exists
	Formals *localVar = findNode(scope, statement->handleVar);

	// pthread_t *thread
	if(localVar != NULL) { // if there is a local var, get its address
		int offset = 16 + 8 * (scope->n - localVar->n);
		printf("	lea %d(%%rbp), %%rdi\n", offset);
	} else { // otherwise, use the global one's address
		Formals *globalVar = addGlobalVar(statement->handleVar);
		printf("	lea %s_var(%%rip), %%rdi\n", globalVar->first);
	}

	// const pthread_attr_t *attr
	printf("	mov $0, %%rsi\n");
	// void *(*start_routine)(void *)
	printf("	lea %s_fun(%%rip), %%rdx\n", statement->asyncFunName);
	// void *arg
	printf("	mov $0, %%rcx\n");

	// make the actual call to pthread_create
	printf("	mov $0, %%rax\n");
	printf("	call %s\n", PCREATE_NAME);
}

void genAwait(Statement *statement, Formals *scope) {
	// load the arguments for pthread_join
	genExpression(statement->awaitHandle, scope);
	printf("	pop %%rdi\n");

	// see if a local var with that name exists
	Formals *localVar = findNode(scope, statement->retVar);

	if(localVar != NULL) { // if there is a local var, get its address
		int offset = 16 + 8 * (scope->n - localVar->n);
		printf("	lea %d(%%rbp), %%rsi\n", offset);
	} else { // otherwise, use the global one's address
		Formals *globalVar = addGlobalVar(statement->retVar);
		printf("	lea %s_var(%%rip), %%rsi\n", globalVar->first);
	}

	// make the actual call to pthread_join
	printf("	mov $0, %%rax\n");
	printf("	call %s\n", PJOIN_NAME);
}

void genIf(Statement *statement, Formals *scope) {
	int labelNum = labelCounter++;

	// generate the condition and set flags accordingly
	genExpression(statement->ifCondition, scope);
	genEvalBoolean();

	// if false, go to the else part
	printf("	je else_%d\n", labelNum);

	// if true, continue to the then part
	genStatement(statement->ifThen, scope);
	// after running the then part, skip the else
	printf("	jmp after_%d\n", labelNum);

	// generate the else part, if there is one
	printf("	else_%d:\n", labelNum);
	if(statement->ifElse != NULL) {
		genStatement(statement->ifElse, scope);
	}

	// put the after label after the whole construct
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

	// reset the stack pointers
	printf("	mov %%rbp, %%rsp\n");
	printf("	pop %%rbp\n");

	// get return address
	printf("	pop %%rcx\n");

	// consume args
	size_t numArgs = (scope != NULL) ? scope->n : 0;
	printf("	add $%lu, %%rsp\n", numArgs * 8);

	// printf("	ret\n");
	printf("	push %%rcx\n");
	printf("	ret\n");
}

int main() {
	// set up the default return statement
	defaultReturn = calloc(1, sizeof(Statement));
	defaultReturn->kind = sReturn;

	defaultReturn->returnValue = calloc(1, sizeof(Expression));
	defaultReturn->returnValue->kind = eVAL;
	defaultReturn->returnValue->val = 0;

	// parse the code
	// funs = tree;
	funs = parse();

	optimize(funs);

	// begin the .text section (code)
	printf(".text\n");
	// make main accessible from other files
	printf("	.global %s\n", MAIN_NAME);

	// declare printf
	printf("	.extern %s\n", PRINTF_NAME);
	printf("	.extern %s\n", SCANF_NAME);
	printf("	.extern %s\n", MEMCPY_NAME);
	printf("	.extern %s\n", PCREATE_NAME);
	printf("	.extern %s\n", PJOIN_NAME);
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
	}

	FOREACH(closures) {
		printf("%s_closure_data: .zero %lu\n", __item->first->name, __item->first->numArgs * 8);
	}

	return 0;
}
