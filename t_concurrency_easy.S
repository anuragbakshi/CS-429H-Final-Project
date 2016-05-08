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
	push $1
	lea show1_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	lea handle_show1_var(%rip), %rdi
	mov $0, %rsi
	lea show1_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	push handle_show1_var(%rip)
	pop %rdi
	lea x_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push $2
	call show_fun
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

show_fun:
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

show_const_fun:
	push %rbp
	mov %rsp, %rbp
	push $100
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

show1_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea show1_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp show_fun

.data
printf_format: .string "%d\n"
scanf_format: .string "%d"
x_var: .quad 0
handle_show1_var: .quad 0
show1_closure_data: .zero 8
