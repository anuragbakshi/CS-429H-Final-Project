.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
	jmp main_fun

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $2
	pop %rax
	mov %rax, x_var(%rip)
	push x_var(%rip)
	push $2
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	cmp $0, %rax
	je else_0
	push $1
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	jmp after_0
	else_0:
	push $0
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	after_0:
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
