.text
	.global main
	.extern printf
	.extern scanf
	.extern memcpy
	.extern pthread_create
	.extern pthread_join

main:
	jmp main_fun

f4_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	push 24(%rbp)
	push 32(%rbp)
	push 40(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
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
	add $32, %rsp
	push %rcx
	ret

f3_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	push 24(%rbp)
	push 32(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push 32(%rbp)
	push $1
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	push 32(%rbp)
	push 24(%rbp)
	push 16(%rbp)
	call f4_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push 16(%rbp)
	push 24(%rbp)
	push 32(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
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
	add $24, %rsp
	push %rcx
	ret

f2_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	push 24(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push 24(%rbp)
	push $1
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	push 24(%rbp)
	push 16(%rbp)
	call f3_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push 16(%rbp)
	push 24(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
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
	add $16, %rsp
	push %rcx
	ret

f1_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push 16(%rbp)
	push $1
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	push 16(%rbp)
	call f2_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
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
	push $2
	call f1_fun
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

.data
printf_format: .string "%d\n"
scanf_format: .string "%d"
x_var: .quad 0
