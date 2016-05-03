.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
	jmp main_fun

main_fun:
	push %rbp
	mov %rsp, %rbp
	push x_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	push x_var(%rip)
	push $10
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	sete %al
	push %rax
	pop %rax
	cmp $0, %rax
	je else_0
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret
	jmp after_0
	else_0:
	after_0:
	push x_var(%rip)
	push $1
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	call main_fun
	push %rax
	pop %rax
	mov %rax, z_var(%rip)
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

.data
	printf_format: .string "%d\n"
	scanf_format: .string "%d"
	z_var: .quad 0
	z_name: .string "z"
	x_var: .quad 0
	x_name: .string "x"
