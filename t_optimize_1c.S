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
	push $2
	push $3
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	push $4
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	push $5
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
	push a_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $2
	push $3
	push $4
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	push $5
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
	push a_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $2
	push $3
	push $4
	push $5
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
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
