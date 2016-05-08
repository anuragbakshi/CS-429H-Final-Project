.text
	.global main
	.extern printf
	.extern scanf
	.extern memcpy
	.extern pthread_create
	.extern pthread_join

main:
	jmp main_fun

f_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push 24(%rbp)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push 32(%rbp)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
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
	pop %rcx
	add $24, %rsp
	push %rcx
	ret
	jmp after_0
	else_0:
	after_0:
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
	push %rax
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	pop %rcx
	add $24, %rsp
	push %rcx
	ret
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	pop %rcx
	add $24, %rsp
	push %rcx
	ret

factorial_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	push $1
	push $1
	call f_fun
	push %rax
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	pop %rcx
	add $8, %rsp
	push %rcx
	ret
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	pop %rcx
	add $8, %rsp
	push %rcx
	ret

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $5
	call factorial_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	pop %rcx
	add $0, %rsp
	push %rcx
	ret

.data
printf_format: .string "%d\n"
scanf_format: .string "%d"
