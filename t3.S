.text
	.global _main
	.extern _printf
	.extern _scanf

_main:
	jmp main_fun

factorial_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	push $0
	pop %rax
	mov %rax, i_var(%rip)
	push $1
	pop %rax
	mov %rax, v_var(%rip)
	loop_0:
	push 16(%rbp)
	push i_var(%rip)
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	setb %al
	push %rax
	pop %rax
	cmp $0, %rax
	je after0
	push i_var(%rip)
	push $1
	pop %rcx
	pop %rax
	add %rcx, %rax
	push %rax
	pop %rax
	mov %rax, i_var(%rip)
	push v_var(%rip)
	push i_var(%rip)
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	pop %rax
	mov %rax, v_var(%rip)
	jmp loop_0
	after0:
	push v_var(%rip)
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
	sub $8, %rsp
	push $0
	call factorial_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	push $1
	call factorial_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	sub $8, %rsp
	push $2
	call factorial_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	push $3
	call factorial_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	sub $8, %rsp
	push $4
	call factorial_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	push $5
	call factorial_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	sub $8, %rsp
	push $6
	call factorial_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	push $10
	call factorial_fun
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
	v_var: .quad 0
	v_name: .string "v"
	i_var: .quad 0
	i_name: .string "i"
