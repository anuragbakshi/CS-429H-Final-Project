.text
	.global _main
	.extern _printf

_main:
	jmp main_fun

z_fun:
	push %rbp
	mov %rsp, %rbp
	push 160(%rbp)
	push 168(%rbp)
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $29
	push $28
	push $27
	push $26
	push $25
	push $24
	push $23
	push $22
	push $21
	push $20
	push $19
	push $18
	push $17
	push $16
	push $15
	push $14
	push $13
	push $12
	push $11
	push $10
	push $9
	push $8
	push $7
	push $6
	push $5
	push $4
	push $3
	push $2
	push $1
	push $0
	call z_fun
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
