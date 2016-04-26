.text
	.global _main
	.extern _printf

_main:
	jmp main_fun

things_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	lea format(%rip), %rdi
	pop %rsi
	call _printf
	push 24(%rbp)
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
	push $40
	push $30
	push $20
	push $10
	call things_fun
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
	push $200
	push $100
	call things_fun
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

.data
	format: .string "%d\n"
	a_var: .quad 0
	a_name: .string "a"
