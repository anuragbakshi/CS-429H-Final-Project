.text
	.global main
	.extern printf
	.extern scanf
	.extern memcpy
	.extern pthread_create
	.extern pthread_join

main:
	jmp main_fun

z_fun:
	push %rbp
	mov %rsp, %rbp
	push 160(%rbp)
	push 168(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	pop %rcx
	add $160, %rsp
	push %rcx
	ret
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	pop %rcx
	add $160, %rsp
	push %rcx
	ret

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $19
	push $18
	push $17
	push $16
	push $15
	push $14
	push $13
	push $12
	push $11
	push $10
	push $9
	push $8
	push $7
	push $6
	push $5
	push $4
	push $3
	push $2
	push $1
	push $0
	call z_fun
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
