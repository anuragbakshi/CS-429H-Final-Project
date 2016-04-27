.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
	jmp main_fun

f_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	push 24(%rbp)
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	push 32(%rbp)
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	push 24(%rbp)
	push 32(%rbp)
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	sete %al
	push %rax
	pop %rax
	cmp $0, %rax
	je else_0
	push 16(%rbp)
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret
	jmp after_0
	else_0:
	after_0:
	sub $8, %rsp
	push 32(%rbp)
	push 24(%rbp)
	push $1
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	push 16(%rbp)
	push 24(%rbp)
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	call f_fun
	add $8, %rsp
	push %rax
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

factorial_fun:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	push 16(%rbp)
	push $1
	push $1
	call f_fun
	add $8, %rsp
	push %rax
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
	sub $8, %rsp
	push $5
	call factorial_fun
	add $8, %rsp
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

.data
	printf_format: .string "%d\n"
	scanf_format: .string "%d"
