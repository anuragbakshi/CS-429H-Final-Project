.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
	jmp main_fun

b_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	push 24(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	lea format(%rip), %rdi
	pop %rsi
	call _printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

c_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	push 24(%rbp)
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	lea format(%rip), %rdi
	pop %rsi
	call _printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

a_fun:
	push %rbp
	mov %rsp, %rbp
	push 24(%rbp)
	push 16(%rbp)
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	seta %al
	push %rax
	pop %rax
	cmp $0, %rax
	je else_0
	push 24(%rbp)
	push 16(%rbp)
	call b_fun
	push %rax
	pop %rax
	mov %rax, z_var(%rip)
	jmp after_0
	else_0:
	push 24(%rbp)
	push 16(%rbp)
	call c_fun
	push %rax
	pop %rax
	mov %rax, z_var(%rip)
	after_0:
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $20
	push $10
	call a_fun
	push %rax
	pop %rax
	mov %rax, z_var(%rip)
	push $10
	push $20
	call a_fun
	push %rax
	pop %rax
	mov %rax, z_var(%rip)
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

.data
	format: .string "%d\n"
	z_var: .quad 0
	z_name: .string "z"
