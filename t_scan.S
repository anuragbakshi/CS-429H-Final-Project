.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
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
	call _printf
	lea scanf_format(%rip), %rdi
	lea x_var(%rip), %rsi
	call _scanf
	push x_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

.data
	printf_format: .string "%d\n"
	scanf_format: .string "%d"
	x_var: .quad 0
	x_name: .string "x"
