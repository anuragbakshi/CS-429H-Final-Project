.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
	jmp main_fun

a_fun:
	push %rbp
	mov %rsp, %rbp
	push x_var(%rip)
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

b_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $100
	pop %rax
	mov %rax, x_var(%rip)
	sub $8, %rsp
	push $20
	call a_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	push $30
	call b_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
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
