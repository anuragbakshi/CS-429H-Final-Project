.text
	.global main
	.extern printf
	.extern scanf
	.extern memcpy
	.extern pthread_create
	.extern pthread_join

main:
	jmp main_fun

a_fun:
	push %rbp
	mov %rsp, %rbp
	push x_var(%rip)
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

b_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
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
	push $100
	pop %rax
	mov %rax, x_var(%rip)
	push $20
	call a_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $30
	call b_fun
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
x_var: .quad 0
