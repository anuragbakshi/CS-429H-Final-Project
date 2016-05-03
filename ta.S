.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
	jmp main_fun

f1_fun:
	push %rbp
	mov %rsp, %rbp
	push zztop_var(%rip)
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

f2_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	pop %rax
	mov %rax, zztop_var(%rip)
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

main_fun:
	push %rbp
	mov %rsp, %rbp
	call f1_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	sub $8, %rsp
	push $14
	call f2_fun
	add $8, %rsp
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
	sub $8, %rsp
	call f1_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
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
	printf_format: .string "%d\n"
	scanf_format: .string "%d"
	a_var: .quad 0
	a_name: .string "a"
	zztop_var: .quad 0
	zztop_name: .string "zztop"
