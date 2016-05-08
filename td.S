.text
	.global main
	.extern printf
	.extern scanf
	.extern memcpy
	.extern pthread_create
	.extern pthread_join

main:
	jmp main_fun

it_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
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
	push $0
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $1
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $2
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $3
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $4
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $5
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $6
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $7
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $8
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $9
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	pop %rcx
	add $0, %rsp
	push %rcx
	ret
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
