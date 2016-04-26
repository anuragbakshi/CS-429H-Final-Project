.text
	.global _main
	.extern _printf

_main:
	jmp main_fun

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $2
	push $3
	push $4
	pop %rcx
	pop %rax
	imul %rcx, %rax
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
	lea format(%rip), %rdi
	pop %rsi
	call _printf
	push $2
	push $3
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	push $4
	pop %rcx
	pop %rax
	imul %rcx, %rax
	push %rax
	push $5
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	lea format(%rip), %rdi
	pop %rsi
	call _printf
	push $2
	push $3
	push $4
	pop %rcx
	pop %rax
	imul %rcx, %rax
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
	lea format(%rip), %rdi
	pop %rsi
	call _printf
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
	imul %rcx, %rax
	push %rax
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

.data
	format: .string "%d\n"
