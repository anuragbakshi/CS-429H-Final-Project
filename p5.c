#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <inttypes.h>
#include "parser.h"

/*
REFERENCES:
All from p4 (calling conventions, etc)
Discussed general PPC stuff with Quang Duong

General architechure info:
http://www.ibm.com/developerworks/library/l-powasm1/
http://physinfo.ulb.ac.be/divers_html/powerpc_programming_info/intro_to_ppc/ppc4_runtime4.html
http://refspecs.linuxfoundation.org/ELF/ppc64/PPC-elf64abi.html#FUNC-DES

Instruction references:
http://www.tentech.ca/downloads/other/PPC_Quick_Ref_Card-Rev1_Oct12_2010.pdf
http://www.ds.ewi.tudelft.nl/vakken/in1006/instruction-set/
*/

/*
r2 = stack base pointer
r1 = stack top pointer

r6 = between stack and global var mem (+ is globals, - is stack)

r15 = argument to printf
r25, r26 = general operands
r27 = random extra space
*/

// make iterating over linked lists easy
#define FOREACH(START) for(typeof(*(START)) *__item = (START); __item != NULL; __item = __item->rest)

// a list of all the global vars
Formals *globalScope = NULL;
// statement that returns 0 (added to the end of all methods)
Statement *defaultReturn = NULL;

// used to generate unique labels
int labelCounter = 0;

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

void genFun(Fun *);
void genStatement(Statement *, Formals *);
void genLoadSingle();
void genLoadOperands();
void genSaveResult();
void genEvalBoolean();
void genExpression(Expression *, Formals *);

void genFun(Fun *function) {
	// create the label and save the previous base pointer
	printf("%s_fun:\n", function->name);

	// push return address
	printf("	mflr 15\n");
	printf("	push 15\n");

	// push stack base pointer
	printf("	push 2\n");
	// set the base pointer to after existing data
	printf("	mr 2, 1\n");

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
			genLoadSingle();

			if(localVar != NULL) { // if there is a local var, set that
				int offset = 16 + 8 * (scope->n - localVar->n);
				printf("	std 25, %d(2)\n", offset);
			} else { // otherwise, set the global one
				Formals *globalVar = addGlobalVar(statement->assignName);
				printf("	std 25, %d(6)\n", 8 * globalVar->n);
			}
		} break;

		case sPrint: {
			// generate the value being printed
			genExpression(statement->printValue, scope);

			// load the argument and call print
			printf("	pop 15\n");
			printf("	bl print\n");
		} break;

		case sIf: {
			int labelNum = labelCounter++;

			printf("	# if\n");

			// generate the condition and set flags accordingly
			genExpression(statement->ifCondition, scope);
			genEvalBoolean();

			// if false, go to the else part
			printf("	beq else_%d\n", labelNum);

			// if true, continue to the then part
			genStatement(statement->ifThen, scope);
			// after running the then part, skip the else
			printf("	b after_%d\n", labelNum);

			// generate the else part, if there is one
			printf("	# else\n");
			printf("	else_%d:\n", labelNum);
			if(statement->ifElse != NULL) {
				genStatement(statement->ifElse, scope);
			}

			// put the after label after the whole construct
			printf("	# endif\n");
			printf("	after_%d:\n", labelNum);
		} break;

		case sWhile:{
			int labelNum = labelCounter++;

			printf("	# loop\n");

			// label the beginning of the loop
			printf("	loop_%d:\n", labelNum);

			// generate the condition and set flags accordingly
			genExpression(statement->whileCondition, scope);
			genEvalBoolean();

			// if false, skip the loop body
			printf("	beq after%d\n", labelNum);

			genStatement(statement->whileBody, scope);
			// go back to the beginning
			printf("	b loop_%d\n", labelNum);
			// put the after label after the whole construct
			printf("	# endloop\n");
			printf("	after%d:\n", labelNum);
		} break;

		case sBlock: {
			// generate all the statements in the block
			FOREACH(statement->block) genStatement(__item->first, scope);
		} break;

		case sReturn: {
			// generate the value being returned and put it into %rax
			genExpression(statement->returnValue, scope);
			genLoadSingle();

			// reset the stack pointers
			printf("	mr 1, 2\n");

			printf("	pop 2\n");

			printf("	pop 15\n");
			printf("	mtlr 15\n");
			printf("	blr\n");
		} break;
	}
}

/* load operand for unary operations */
void genLoadSingle() {
	printf("	pop 25\n");
}

/* load operands for binary operations */
void genLoadOperands() {
	genLoadSingle();

	printf("	pop 26\n");
}

/* push the result onto the stack */
void genSaveResult() {
	printf("	push 25\n");
}

/* set the flags for a boolean value (0 = false, !0 = true) */
void genEvalBoolean() {
	genLoadSingle();

	printf("	cmpdi 25, 0\n");
}

void genExpression(Expression *expression, Formals *scope) {
	switch(expression->kind) {
		case eVAR: {
			// very similar to sAssignment
			Formals *localVar = findNode(scope, expression->varName);

			if(localVar != NULL) {
				printf("	# load local %s\n", localVar->first);

				int offset = 16 + 8 * (scope->n - localVar->n);
				printf("	ld 15, %d(2)\n", offset);
				printf("	push 15\n");
			} else {
				Formals *globalVar = addGlobalVar(expression->varName);

				printf("	# load global %s\n", globalVar->first);

				printf("	ld 15, %d(6)\n", 8 * globalVar->n);
				printf("	push 15\n");
			}
		} break;

		case eVAL: {
			// push the immediate value onto the stack
			printf("	# load immediate 0x%"PRIx64"\n", expression->val);

			// shift each 16-bit block into the register (high to low)
			printf("	xor 15, 15, 15\n");
			printf("	oris 15, 15, 0x%x\n", (uint16_t) ((expression->val >> 48) & 0xffff));
			printf("	oris 15, 15, 0x%x\n", (uint16_t) ((expression->val >> 32) & 0xffff));
			printf("	oris 15, 15, 0x%x\n", (uint16_t) ((expression->val >> 16) & 0xffff));
			printf("	ori 15, 15, 0x%x\n", (uint16_t) (expression->val & 0xffff));

			printf("	push 15\n");
		} break;

		case ePLUS: {
			// generate the LHS and RHS
			genExpression(expression->left, scope);
			genExpression(expression->right, scope);

			printf("	# +\n");

			// do the addition
			genLoadOperands();
			printf("	add 25, 25, 26\n");
			genSaveResult();
		} break;

		case eMUL: {
			// same as ePLUS
			genExpression(expression->left, scope);
			genExpression(expression->right, scope);

			printf("	# *\n");

			genLoadOperands();
			// printf("	xor 27, 27, 27\n");
			// // move one operand into r27
			// printf("	mr 27, 25\n");
			// // multiply the high word and shift it into place
			// printf("	mulhw 25, 26, 27\n");
			// printf("	sldi 25, 25, 16\n");
			// printf("	sldi 25, 25, 16\n");
			// // multiply the low word and put it into place
			// printf("	mullw 27, 26, 27\n");
			// printf("	or 25, 25, 27\n");
			printf("	mulld 25, 25, 26\n");
			genSaveResult();
		} break;

		case eEQ: {
			// similar to ePLUS
			genExpression(expression->left, scope);
			genExpression(expression->right, scope);

			printf("	# ==\n");

			genLoadOperands();
			// compare the operands and push 0 if false, and 1 if true
			printf("	cmpd 25, 26\n");
			printf("	mfcr 25\n");
			printf("	srdi 25, 25, 29\n");
			printf("	andi. 25, 25, 1\n");
			genSaveResult();
		} break;

		case eNE: {
			// same as eEQ
			genExpression(expression->left, scope);
			genExpression(expression->right, scope);

			printf("	# !=\n");

			genLoadOperands();
			printf("	cmpd 25, 26\n");
			printf("	mfcr 25\n");
			printf("	srdi 25, 25, 29\n");
			printf("	andi. 25, 25, 1\n");
			printf("	xori 25, 25, 1\n");
			genSaveResult();
		} break;

		case eLT: {
			// same as eEQ
			genExpression(expression->right, scope);
			genExpression(expression->left, scope);

			printf("	# <\n");

			genLoadOperands();
			printf("	cmpd 25, 26\n");
			printf("	mfcr 25\n");
			printf("	srdi 25, 25, 31\n");
			printf("	andi. 25, 25, 1\n");
			genSaveResult();
		} break;

		case eGT: {
			// same as eEQ
			genExpression(expression->right, scope);
			genExpression(expression->left, scope);

			printf("	# >\n");

			genLoadOperands();
			printf("	cmpd 25, 26\n");
			printf("	mfcr 25\n");
			printf("	srdi 25, 25, 30\n");
			printf("	andi. 25, 25, 1\n");
			genSaveResult();
		} break;

		case eCALL: {
			printf("	# %s(...)\n", expression->callName);

			// push arguments onto stack
			FOREACH(expression->callActuals) {
				genExpression(__item->first, scope);
			}

			// call the function
			printf("	bl %s_fun\n", expression->callName);

			// push return value onto stack
			genSaveResult();
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

	globalScope = calloc(1, sizeof(Formals));
	globalScope->first = "";

	// parse the code
	Funs *p = parse();

	// use macros to emulate stack functionality
	printf(".macro push reg\n");
	printf("	addi 1, 1, -8\n");
	printf("	std \\reg, 0(1)\n");
	printf(".endm\n");

	printf(".macro pop reg\n");
	printf("	ld \\reg, 0(1)\n");
	printf("	addi 1, 1, 8\n");
	printf(".endm\n");

	// make main accessible from other files
	printf(".global main\n");
	printf("\n");

	// generate the program entry point
	printf("main:\n");
	printf("	mr 6, 2\n");
	printf("	addi 2, 2, -8\n");
	printf("	mr 1, 2\n");
	printf("	bl main_fun\n");
	printf("	mr 6, 25\n");
	printf("	b exit\n");
	printf("\n");

	// generate all the function
	FOREACH(p) genFun(__item->first);

	// begin the .data section (8 KB for stack, 8 * n bytes for globals)
	printf(".data\n");
	printf(".fill 8192\n");
	printf("stack_base:\n");
	printf("data: .fill %d\n", 8 * globalScope->n);
	printf("\n");

	printf(".global entry\n");
	printf("entry:\n");
	printf("	.quad main\n");
	printf("	.quad data\n");
	printf("	.quad 0\n");
	printf("\n");

	return 0;
}
