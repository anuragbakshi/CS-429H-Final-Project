.text
	.global main
	.extern printf
	.extern scanf
	.extern memcpy

main:
	jmp main_fun

it_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $0
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $0
	push $1
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $0
	push $1
	push $2
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $0
	push $1
	push $2
	push $3
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $0
	push $1
	push $2
	push $3
	push $4
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $0
	push $1
	push $2
	push $3
	push $4
	push $5
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $0
	push $1
	push $2
	push $3
	push $4
	push $5
	push $6
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $0
	push $1
	push $2
	push $3
	push $4
	push $5
	push $6
	push $7
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $0
	push $1
	push $2
	push $3
	push $4
	push $5
	push $6
	push $7
	push $8
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $0
	push $1
	push $2
	push $3
	push $4
	push $5
	push $6
	push $7
	push $8
	push $9
	call it_fun
	push %rax
	pop %rax
	mov %rax, x_var(%rip)
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

.data
printf_format: .string "%d\n"
scanf_format: .string "%d"
x_var: .quad 0
