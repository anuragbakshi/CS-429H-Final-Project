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
	push $0
	pop %rax
	mov %rax, x_var(%rip)
	push x_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	lea scanf_format(%rip), %rdi
	lea x_var(%rip), %rsi
	mov $0, %rax
	call scanf
	push x_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $10
	call scan_n_fun
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

scan_n_fun:
	push %rbp
	mov %rsp, %rbp
	loop_0:
	push $0
	push 16(%rbp)
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	seta %al
	push %rax
	pop %rax
	cmp $0, %rax
	je after0
	lea scanf_format(%rip), %rdi
	lea x_var(%rip), %rsi
	mov $0, %rax
	call scanf
	push x_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push 16(%rbp)
	push $1
	pop %rcx
	pop %rax
	sub %rcx, %rax
	push %rax
	pop %rax
	mov %rax, 16(%rbp)
	jmp loop_0
	after0:
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	pop %rcx
	add $8, %rsp
	push %rcx
	ret

.data
printf_format: .string "%d\n"
scanf_format: .string "%d"
x_var: .quad 0
