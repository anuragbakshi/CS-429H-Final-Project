.text
	.global main
	.extern printf
	.extern scanf
	.extern memcpy
	.extern pthread_create
	.extern pthread_join

main:
	jmp main_fun

things_fun:
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
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	pop %rcx
	add $16, %rsp
	push %rcx
	ret

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $20
	push $10
	call things_fun
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
	push $200
	push $100
	call things_fun
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
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
a_var: .quad 0
