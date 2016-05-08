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
	push a_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push b_var(%rip)
	push c_var(%rip)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
	push $3
	push $5
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, b_var(%rip)
	push x_var(%rip)
	push $9
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, c_var(%rip)
	push x_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push b_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push a_var(%rip)
	pop %rax
	mov %rax, c_var(%rip)
	push b_var(%rip)
	pop %rax
	mov %rax, m_var(%rip)
	push c_var(%rip)
	pop %rax
	mov %rax, n_var(%rip)
	push n_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push l_var(%rip)
	push m_var(%rip)
	push n_var(%rip)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, c_var(%rip)
	push $1
	pop %rax
	mov %rax, c_var(%rip)
	push c_var(%rip)
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
l_var: .quad 0
n_var: .quad 0
m_var: .quad 0
x_var: .quad 0
c_var: .quad 0
b_var: .quad 0
a_var: .quad 0
