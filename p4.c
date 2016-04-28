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
#define MAIN_NAME "_main"
#else
#define PRINTF_NAME "printf"
#define SCANF_NAME "scanf"
#define MAIN_NAME "main"
#endif

// make iterating over linked lists easy
#define FOREACH(START) for(typeof(*(START)) *__item = (START); __item != NULL; __item = __item->rest)

// a list of all the global vars
Formals *globalScope = NULL;
// statement that returns 0 (added to the end of all methods)
Statement *defaultReturn = NULL;

// true if the stack is aligned to 16 bytes
bool stackAligned = false;
// used to generate unique labels
int labelCounter = 0;

/* finds the node with the specified item */
Formals *findNode(Formals *list, char *str) {
	Formals *current = list;
	// iterate over each node in the list
	while(current != NULL) {
		// if the node's item matches the search item, return the current node
		if(strcmp(current->first->name, str) == 0) {
			return current;
		}

		// advance to the next node
		current = current->rest;
	}

	return NULL;
}

Formal *addGlobalVar(char *str) {
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

		new_node->first = calloc(1, sizeof(Formal));

		new_node->first->name = str;
		new_node->first->func = NULL;
		new_node->rest = globalScope;

		globalScope = new_node;
	} else { // if it exists, return it
		return node->first;
	}

	return globalScope->first;
}

void genFun(Fun *);
void genStatement(Statement *, Formals *);
void genLoadOperands();
void genSaveResult();
void genEvalBoolean();
void genExpression(Expression *, Formals *);

void genFun(Fun *function) {
	// stack is misaligned at the beginning of a function
	stackAligned = false;

	// create the label and save the previous base pointer
	printf("%s_fun:\n", function->name);
	printf("	push %%rbp\n");
	stackAligned = !stackAligned;
	// set the base pointer to after existing data
	printf("	mov %%rsp, %%rbp\n");

	// generate the body and add the default return statement
	genStatement(function->body, function->formals);
	genStatement(defaultReturn, function->formals);

	printf("\n");
}

void genStatement(Statement *statement, Formals *scope) {
	switch(statement->kind) {
		case sAssignment: {
			// see if a local var with that name exists
			Formals *localVar = findNode(scope, statement->assignName);

			// generate the RHS and load it into %rax
			genExpression(statement->assignValue, scope);
			printf("	pop %%rax\n");
			stackAligned = !stackAligned;

			if(localVar != NULL) { // if there is a local var, set that
				int offset = 16 + 8 * (scope->n - localVar->n);
				printf("	mov %%rax, %d(%%rbp)\n", offset);
			} else { // otherwise, set the global one
				Formal *globalVar = addGlobalVar(statement->assignName);
				printf("	mov %%rax, %s_var(%%rip)\n", globalVar->name);
			}
		} break;

		case sPrint: {
			// generate the value being printed
			genExpression(statement->printValue, scope);

			// load the arguments for printf
			printf("	lea printf_format(%%rip), %%rdi\n");
			printf("	pop %%rsi\n");
			stackAligned = !stackAligned;

			// if the stack isn't aligned, push 8 bytes
			if(!stackAligned) {
				printf("	sub $8, %%rsp\n");
			}

			// make the actual call to printf
			printf("	call %s\n", PRINTF_NAME);

			// if we had pushed to align, pop to restore the correct stack
			if(!stackAligned) {
				printf("	add $8, %%rsp\n");
			}
		} break;

		case sScan: {
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
				Formal *globalVar = addGlobalVar(statement->scanVar);
				printf("	lea %s_var(%%rip), %%rsi\n", globalVar->name);
			}

			// if the stack isn't aligned, push 8 bytes
			if(!stackAligned) {
				printf("	sub $8, %%rsp\n");
			}

			// make the actual call to scanf
			printf("	call %s\n", SCANF_NAME);

			// if we had pushed to align, pop to restore the correct stack
			if(!stackAligned) {
				printf("	add $8, %%rsp\n");
			}
		} break;

		case sIf: {
			int labelNum = labelCounter++;

			// generate the condition and set flags accordingly
			genExpression(statement->ifCondition, scope);
			genEvalBoolean();

			bool currentAligned = stackAligned;
			// if false, go to the else part
			printf("	je else_%d\n", labelNum);

			// if true, continue to the then part
			genStatement(statement->ifThen, scope);
			// after running the then part, skip the else
			printf("	jmp after_%d\n", labelNum);

			stackAligned = currentAligned;
			// generate the else part, if there is one
			printf("	else_%d:\n", labelNum);
			if(statement->ifElse != NULL) {
				genStatement(statement->ifElse, scope);
			}

			// put the after label after the whole construct
			stackAligned = currentAligned;
			printf("	after_%d:\n", labelNum);
		} break;

		case sWhile:{
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
		} break;

		case sBlock: {
			// generate all the statements in the block
			FOREACH(statement->block) genStatement(__item->first, scope);
		} break;

		case sReturn: {
			// generate the value being returned and put it into %rax
			genExpression(statement->returnValue, scope);
			printf("	pop %%rax\n");
			stackAligned = !stackAligned;

			// reset the stack pointers
			printf("	mov %%rbp, %%rsp\n");
			printf("	pop %%rbp\n");
			stackAligned = !stackAligned;

			printf("	ret\n");
		} break;
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
	stackAligned = !stackAligned;
}

/* set the flags for a boolean value (0 = false, !0 = true) */
void genEvalBoolean() {
	printf("	pop %%rax\n");
	stackAligned = !stackAligned;

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
				Formal *globalVar = addGlobalVar(expression->varName);
				printf("	push %s_var(%%rip)\n", globalVar->name);
			}

			stackAligned = !stackAligned;
		} break;

		case eVAL: {
			// push the immediate value onto the stack
			printf("	push $%"PRIu64"\n", expression->val);
			stackAligned = !stackAligned;
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
			bool currentAligned = stackAligned;
			if(expression->callActuals != NULL) {
				currentAligned ^= expression->callActuals->n & 1;
			}

			// add padding if necessary
			if(!currentAligned) {
				printf("	sub $8, %%rsp\n");
			}

			// push arguments onto stack
			FOREACH(expression->callActuals) {
				genExpression(__item->first, scope);
			}

			// call the function
			printf("	call %s_fun\n", expression->callName);

			// remove the padding if we added it
			if(!currentAligned) {
				printf("	add $8, %%rsp\n");
			}

			stackAligned = currentAligned;

			// push return value onto stack
			printf("	push %%rax\n");
			stackAligned = !stackAligned;
		} break;
	}
}

int main(int argc, char *argv[]) {
	// set up the default return statement
	defaultReturn = calloc(1, sizeof(Statement));
	defaultReturn->kind = sReturn;

	defaultReturn->returnValue = calloc(1, sizeof(Expression));
	defaultReturn->returnValue->kind = eVAL;
	defaultReturn->returnValue->val = 0;

	// parse the code
	Funs *p = parse();

	// begin the .text section (code)
	printf(".text\n");
	// make main accessible from other files
	printf("	.global %s\n", MAIN_NAME);

	// declare printf
	printf("	.extern %s\n", PRINTF_NAME);
	printf("	.extern %s\n", SCANF_NAME);
	printf("\n");

	// generate the program entry point
	printf("%s:\n", MAIN_NAME);
	printf("	jmp main_fun\n");
	printf("\n");

	// generate all the function
	FOREACH(p) genFun(__item->first);

	// begin the .data section (variables)
	printf(".data\n");
	// the format string to print variables on assignment
	printf("	printf_format: .string \"%%d\\n\"\n");
	printf("	scanf_format: .string \"%%d\"\n");

	// generate out allocations for all global vars and their names
	FOREACH(globalScope) {
		printf("	%s_var: .quad 0\n", __item->first->name);
		printf("	%1$s_name: .string \"%1$s\"\n", __item->first->name);
	}

	return 0;
}
