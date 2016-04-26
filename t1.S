.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
	jmp main_fun

main_fun:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	push $2
	push $3
	push $4
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	push $5
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	call show_fun
	add $8, %rsp
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
	push $2
	push $3
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	push $4
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	push $5
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	call show_fun
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
	sub $8, %rsp
	push $2
	push $3
	push $4
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	push $5
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	call show_fun
	add $8, %rsp
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
	push $2
	push $3
	push $4
	push $5
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	call show_fun
	push %rax
	pop %rax
	mov %rax, a_var(%rip)
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

show_fun:
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

.data
	format: .string "%d\n"
	a_var: .quad 0
	a_name: .string "a"
