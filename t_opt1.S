.text
	.global main
	.extern printf
	.extern scanf
	.extern memcpy
	.extern pthread_create
	.extern pthread_join

main:
	jmp main_fun

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $5
	pop %rax
	mov %rax, x_var(%rip)
	push $1
	pop %rax
	mov %rax, a_var(%rip)
	push $0
	pop %rax
	cmp $0, %rax
	je else_0
	push $0
	pop %rax
	mov %rax, a_var(%rip)
	jmp after_0
	else_0:
	push x_var(%rip)
	pop %rax
	mov %rax, a_var(%rip)
	after_0:
	push a_var(%rip)
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
a_var: .quad 0
x_var: .quad 0
