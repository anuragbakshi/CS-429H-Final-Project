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
	push $100
	pop %rax
	mov %rax, a_var(%rip)
	push $20
	pop %rax
	mov %rax, b_var(%rip)
	push a_var(%rip)
	push b_var(%rip)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, add_var(%rip)
	push a_var(%rip)
	push b_var(%rip)
	pop %rcx
	pop %rax
	sub %rcx, %rax
	push %rax
	pop %rax
	mov %rax, sub_var(%rip)
	push a_var(%rip)
	push b_var(%rip)
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	pop %rax
	mov %rax, mul_var(%rip)
	push a_var(%rip)
	push b_var(%rip)
	pop %rcx
	pop %rax
	mov $0, %rdx
	div %rcx
	push %rax
	pop %rax
	mov %rax, div_var(%rip)
	push add_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push sub_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push mul_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push div_var(%rip)
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
div_var: .quad 0
mul_var: .quad 0
sub_var: .quad 0
add_var: .quad 0
b_var: .quad 0
a_var: .quad 0
