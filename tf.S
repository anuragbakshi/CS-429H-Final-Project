.text
	.global main
	.extern printf
	.extern scanf
	.extern memcpy

main:
	jmp main_fun

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $10
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $1
	push $1
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	sete %al
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $1
	push $1
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	setne %al
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $1
	push $1
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	setb %al
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $1
	push $1
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	seta %al
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $1
	push $2
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	sete %al
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $1
	push $2
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	setne %al
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $2
	push $1
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	setb %al
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $2
	push $1
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	seta %al
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $2
	push $1
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	sete %al
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $2
	push $1
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	setne %al
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $1
	push $2
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	setb %al
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $1
	push $2
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	seta %al
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

.data
printf_format: .string "%d\n"
scanf_format: .string "%d"
