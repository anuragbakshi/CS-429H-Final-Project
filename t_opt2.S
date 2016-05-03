.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
	jmp main_fun

main_fun:
	push %rbp
	mov %rsp, %rbp
	push a_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
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
	call _printf
	push b_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
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
	call _printf
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
	call _printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

.data
	printf_format: .string "%d\n"
	scanf_format: .string "%d"
	l_var: .quad 0
	l_name: .string "l"
	n_var: .quad 0
	n_name: .string "n"
	m_var: .quad 0
	m_name: .string "m"
	x_var: .quad 0
	x_name: .string "x"
	c_var: .quad 0
	c_name: .string "c"
	b_var: .quad 0
	b_name: .string "b"
	a_var: .quad 0
	a_name: .string "a"
