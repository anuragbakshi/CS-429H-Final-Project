.text
	.global main
	.extern printf
	.extern scanf
	.extern memcpy

main:
	jmp main_fun

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $104
	pop %rax
	mov %rax, x_var(%rip)
	push x_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

.data
printf_format: .string "%d\n"
scanf_format: .string "%d"
x_var: .quad 0
