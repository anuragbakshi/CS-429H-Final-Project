.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
	jmp main_fun

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $5
	pop %rax
	mov %rax, a_var(%rip)
	push $3
	pop %rax
	mov %rax, m_var(%rip)
	loop_0:
	push n_var(%rip)
	push m_var(%rip)
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	seta %al
	push %rax
	pop %rax
	cmp $0, %rax
	je after0
	push a_var(%rip)
	push $1
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
	push n_var(%rip)
	push $1
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, n_var(%rip)
	push k_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	jmp loop_0
	after0:
	push $5
	push $4
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, d_var(%rip)
	push m_var(%rip)
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
	d_var: .quad 0
	d_name: .string "d"
	k_var: .quad 0
	k_name: .string "k"
	n_var: .quad 0
	n_name: .string "n"
	m_var: .quad 0
	m_name: .string "m"
	a_var: .quad 0
	a_name: .string "a"
