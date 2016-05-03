.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
	jmp main_fun

f4_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	push 24(%rbp)
	push 32(%rbp)
	push 40(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

f3_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	push 24(%rbp)
	push 32(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	push 32(%rbp)
	push $1
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	push 32(%rbp)
	push 24(%rbp)
	push 16(%rbp)
	call f4_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push 16(%rbp)
	push 24(%rbp)
	push 32(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

f2_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	push 24(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	sub $8, %rsp
	push 24(%rbp)
	push $1
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	push 24(%rbp)
	push 16(%rbp)
	call f3_fun
	add $8, %rsp
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push 16(%rbp)
	push 24(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

f1_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	push 16(%rbp)
	push $1
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	push 16(%rbp)
	call f2_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push 16(%rbp)
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

main_fun:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	push $2
	call f1_fun
	add $8, %rsp
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

.data
	printf_format: .string "%d\n"
	scanf_format: .string "%d"
	x_var: .quad 0
	x_name: .string "x"
