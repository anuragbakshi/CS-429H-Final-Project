#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.h"

//TODO figure out endif

static char **symbol_table;
static int symbol_capacity;
static int num_symbols;
static int label_counter;

void record(char *id) {         //string is inserted to symbol table
    if (!(num_symbols < symbol_capacity)) {
        symbol_table = (char **)realloc(symbol_table, symbol_capacity * 2);
        symbol_capacity *= 2;
    }

    symbol_table[num_symbols] = id;
    num_symbols++;
}

int already_recorded(char *id) {        //returns 1 if a var has been seen before
    for (int i = 0; i < num_symbols; i++) {
        if (strcmp(id, symbol_table[i]) == 0) {
            return 1;
        }
    }
    return 0;
}

void set(char *id) {            //checks symbol table for var  and inserts if not there
    if (already_recorded(id))
        return;
    else
        record(id);
}

//which argument is it?

int get_formal_number(char *varName, Formals * formals) {       //TODO
    int counter = 0;
    while (1) {
        if (formals == 0)
            return -1;
        counter += 1;
        if (strcmp(varName, formals->first) == 0)
            return counter;
        else
            formals = formals->rest;
    }
}

void eval_expression();
void handle_statement();

//push those arguments onto the stack

void push_on_stack(Formals * formals, Actuals * actuals) {

    if (actuals == 0)
        return;
    push_on_stack(formals, actuals->rest);
    printf("     push %%r15\n");
    eval_expression(formals, actuals->first);
    printf("     pop %%r15\n");
    printf("     push %%rax\n");

    return;
}

//remove those arguments from the stack

void pop_off_stack(int num_actuals) {
    for (int i = 0; i < num_actuals; i++) {
        printf("    pop TEMP\n");
    }
}

//AKA how far from rbp?

int get_formal_val(int formal_number) {
    int index = 8 * (formal_number - 1);
    return index;
}

// void pop_off_stack() TODO

void eval_expression(Formals * formals, Expression * expression) {
    int formal_number;
    switch (expression->kind) {

    case eVAR:
        formal_number = get_formal_number(expression->varName, formals);
        if (formal_number == -1) {
            char *var = expression->varName;
            set(var);
            printf("    mov %s,%%rax\n", var);
        } else {
            printf("    mov %d(%%rbp),%%rax\n", get_formal_val(formal_number));
            //TODO get val from formal
        }
        break;

    case eVAL:
        printf("    mov $%lu,%%rax\n", expression->val);
        break;

    case ePLUS:
        printf("    push %%r15\n");
        eval_expression(formals, expression->left);
        printf("    pop %%r15\n");
        printf("    mov %%rax,%%r15\n");
        printf("    push %%r15\n");
        eval_expression(formals, expression->right);
        printf("    pop %%r15\n");
        printf("    add %%r15,%%rax\n");
        break;

    case eMUL:
        printf("    push %%r15\n");
        eval_expression(formals, expression->left);
        printf("    pop %%r15\n");
        printf("    mov %%rax,%%r15\n");
        printf("    push %%r15\n");
        eval_expression(formals, expression->right);
        printf("    pop %%r15\n");
        printf("    imul %%r15,%%rax\n");
        break;

    case eEQ:
        printf("    push %%r15\n");
        eval_expression(formals, expression->left);
        printf("    pop %%r15\n");
        printf("    mov %%rax,%%r15\n");
        printf("    push %%r15\n");
        eval_expression(formals, expression->right);
        printf("    pop %%r15\n");
        printf("    cmp %%r15,%%rax\n");
        printf("    setz %%al\n");
        printf("    movzx %%al,%%rax\n");
        break;

    case eNE:
        printf("    push %%r15\n");
        eval_expression(formals, expression->left);
        printf("    pop %%r15\n");
        printf("    mov %%rax,%%r15\n");
        printf("    push %%r15\n");
        eval_expression(formals, expression->right);
        printf("    pop %%r15\n");
        printf("    cmp %%r15,%%rax\n");
        printf("    setnz %%al\n");
        printf("    movzx %%al,%%rax\n");
        break;

    case eLT:
        printf("    push %%r15\n");
        eval_expression(formals, expression->left);
        printf("    pop %%r15\n");
        printf("    mov %%rax,%%r15\n");
        printf("    push %%r15\n");
        eval_expression(formals, expression->right);
        printf("    pop %%r15\n");
        printf("    cmp %%r15,%%rax\n");
        printf("    seta %%al\n");
        printf("    movzx %%al,%%rax\n");
        break;                  //TODO verify

    case eGT:
        printf("    push %%r15\n");
        eval_expression(formals, expression->left);
        printf("    pop %%r15\n");
        printf("    mov %%rax,%%r15\n");
        printf("    push %%r15\n");
        eval_expression(formals, expression->right);
        printf("    pop %%r15\n");
        printf("    cmp %%r15,%%rax\n");
        printf("    setb %%al\n");
        printf("    movzx %%al,%%rax\n");
        break;

    case eCALL:
        push_on_stack(formals, expression->callActuals);
        printf("    mov %%rsp,%%r11\n");
        printf("    and BIG,%%rsp\n");
        printf("    push %%r11\n");
        printf("    push %%r11\n");
        if(strcmp(expression->callName, "main") == 0) {
            printf("    call main\n");
        } else {
            printf("    call _%s\n", expression->callName);
        }
        printf("    pop %%rsp\n");
        if(expression->callActuals != 0) {
            pop_off_stack(expression->callActuals->n);
        }
        
        
        break;
    }
}

void handle_print(Formals * formals, Statement * statement) {
    printf("    push %%r15\n");
    eval_expression(formals, statement->printValue);
    printf("    pop %%r15\n");
    printf("    mov $p4_format,%%rdi\n");
    printf("    mov %%rax,%%rsi\n");
    printf("    push %%rax\n");
    printf("    mov $0,%%rax\n");
    printf("    mov %%rsp,%%r11\n");
    printf("    and BIG,%%rsp\n");
    printf("    push %%r11\n");
    printf("    push %%r11\n");
    printf("    call printf\n");
    printf("    pop %%rsp\n");
    printf("    pop %%rax\n");
}

void handle_assignment(Formals * formals, Statement * statement) {

    set(statement->assignName);
    printf("    push %%r15\n");
    eval_expression(formals, statement->assignValue);
    printf("    pop %%r15\n");
    printf("    mov %%rax,%s\n", statement->assignName);
}

void handle_if(Formals * formals, Statement * statement) {
    printf("    push %%r15\n");
    eval_expression(formals, statement->ifCondition);
    printf("    pop %%r15\n");
    printf("    cmp $0,%%rax\n");
    int curr_label = label_counter;
    label_counter += 1;
    printf("    jz ELSE%d\n", curr_label);
    handle_statement(formals, statement->ifThen);
    printf("    jmp DONE%d\n", curr_label);
    printf("    ELSE%d:\n", curr_label);
    if ((statement->ifElse) != 0) {
        handle_statement(formals, statement->ifElse);
    }
    printf("    DONE%d:\n", curr_label);

}
void handle_while(Formals * formals, Statement * statement) {
    int curr_label = label_counter;
    printf("    CONDITION%d:\n", curr_label);
    printf("    push %%r15\n");
    eval_expression(formals, statement->whileCondition);
    printf("    pop %%r15\n");
    printf("    cmp $0,%%rax\n");
    printf("    jz DONE%d\n", curr_label);
    handle_statement(formals, statement->whileBody);
    printf("    jmp CONDITION%d\n", curr_label);
    printf("    DONE%d:\n", curr_label);
}
void handle_return(Formals * formals, Statement * statement) {
    eval_expression(formals, statement->returnValue);
    //CLEAN WHAT YOU USE
    printf("    pop %%rbp\n");
    printf("    ret\n");
}
void handle_block(Formals * formals, Statement * statement) {
    Block *block = statement->block;
    while (1) {
        if (block == 0)
            break;
        handle_statement(formals, block->first);
        block = block->rest;
    }
}

void handle_statement(Formals * formals, Statement * statement) {
    switch (statement->kind) {
    case sAssignment:
        handle_assignment(formals, statement);
        break;
    case sPrint:
        handle_print(formals, statement);
        break;
    case sIf:
        handle_if(formals, statement);
        break;
    case sWhile:
        handle_while(formals, statement);
        break;
    case sBlock:
        handle_block(formals, statement);
        break;
    case sReturn:
        handle_return(formals, statement);
    }
}

void handle_func(Fun * p) {
    handle_statement(p->formals, p->body);
}

void genFun(Fun * p) {
    //different rules for main and others
    printf("    .global %s\n", p->name);
    if(strcmp(p->name, "main") == 0) {
        printf("%s:\n", p->name);
        printf("    push %%rbp\n");
        printf("    mov %%rsp,%%rbp\n");
        printf("    mov $0,%%rax\n");
        handle_func(p);
        printf("    pop %%rbp\n");
        printf("    mov $0,%%rax\n");
        printf("    ret\n");
    } else {
        printf("_%s:\n", p->name);
        printf("    push %%rbp\n");
        printf("    mov 16(%%rsp),%%rbp\n");
        printf("    mov $0,%%rax\n");
        handle_func(p);
        printf("    pop %%rbp\n");
        printf("    mov $0,%%rax\n");
        printf("    ret\n");
    }
}

void genFuns(Funs * p) {
    if (p == 0)
        return;
    genFun(p->first);
    genFuns(p->rest);
}

void print_data_section() {
    printf("    .data\n");
    //print format string
    printf("    p4_format:\n");
    char formatString[] = "%lu\n";
    for (int i = 0; i < sizeof(formatString); i++) {
        printf("        .byte %d\n", formatString[i]);
    }
    //garbage var
    printf("    TEMP: .quad 0\n");
    //used for anding
    printf("    BIG: .quad -0x10\n");
    for (int i = 0; i < num_symbols; i++) {
        printf("    %s: .quad 0\n", symbol_table[i]);
    }
}

void free_symbol_table() {      //mama told me to clean up after myself
    for (int i = 0; i < num_symbols; i++) {
        free(symbol_table[i]);
    }
    free(symbol_table);
}

void initialize_global_vars() {
    //initialize symbol table
    symbol_table = (char **)malloc(16 * sizeof(char *));
    symbol_capacity = 16;
    //initialize metrics
    num_symbols = 0;
    label_counter = 0;
}

int print_assembly(Funs *p) {


        
    initialize_global_vars();

    printf("    .text\n");
    genFuns(p);

    print_data_section();
    free_symbol_table();

    return 0;

}

Funs *optimize(Funs *p) {
    //TODO    
    return 0;
}

int main(int argc, char *argv[]) {

    Funs *p = parse();
    p = optimize(p);
    print_assembly(p);

    return 0;
}
