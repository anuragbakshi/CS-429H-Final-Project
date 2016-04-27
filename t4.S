.text
	.global _main
	.extern _printf
	.extern _scanf

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
	lea printf_format(%rip), %rdi
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
	mul %rcx
	push %rax
	push $5
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
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
	lea printf_format(%rip), %rdi
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
	mul %rcx
	push %rax
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
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
