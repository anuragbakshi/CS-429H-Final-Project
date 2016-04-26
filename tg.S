.text
	.global _main
	.extern _printf

_main:
	jmp main_fun

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $100488
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
