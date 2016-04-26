.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
	jmp main_fun

printf_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	lea format(%rip), %rdi
	pop %rsi
	call _printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

main_fun:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	push $100
	call printf_fun
	add $8, %rsp
	push %rax
	pop %rax
	mov %rax, v_var(%rip)
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

.data
	format: .string "%d\n"
	v_var: .quad 0
	v_name: .string "v"
