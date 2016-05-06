.text
	.global _main
	.extern _printf
	.extern _scanf
	.extern _memcpy

_main:
	jmp main_fun

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $1
	lea identity_closure_data(%rip), %rdi
	lea 8(%rsp), %rsi
	mov 8, %rdx
	sub $8, %rsp
	call _memcpy
	add $8, %rsp
	add 8, %rsp
	push $2
	lea squarer_closure_data(%rip), %rdi
	lea 8(%rsp), %rsi
	mov 8, %rdx
	sub $8, %rsp
	call _memcpy
	add $8, %rsp
	add 8, %rsp
	push $3
	lea cuber_closure_data(%rip), %rdi
	lea 8(%rsp), %rsi
	mov 8, %rdx
	sub $8, %rsp
	call _memcpy
	add $8, %rsp
	add 8, %rsp
	sub $8, %rsp
	push $5
	call identity_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	push $5
	call squarer_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	call _printf
	sub $8, %rsp
	push $5
	call cuber_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	push $6
	lea identity6_closure_data(%rip), %rdi
	lea 8(%rsp), %rsi
	mov 8, %rdx
	call _memcpy
	add 8, %rsp
	push $6
	lea squarer6_closure_data(%rip), %rdi
	lea 8(%rsp), %rsi
	mov 8, %rdx
	call _memcpy
	add 8, %rsp
	push $6
	lea cuber6_closure_data(%rip), %rdi
	lea 8(%rsp), %rsi
	mov 8, %rdx
	call _memcpy
	add 8, %rsp
	sub $8, %rsp
	call identity6_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	sub $8, %rsp
	call squarer6_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	sub $8, %rsp
	call cuber6_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	push $1
	push $7
	lea identity7_closure_data(%rip), %rdi
	lea 16(%rsp), %rsi
	mov 16, %rdx
	sub $8, %rsp
	call _memcpy
	add $8, %rsp
	add 16, %rsp
	push $2
	push $7
	lea squarer7_closure_data(%rip), %rdi
	lea 16(%rsp), %rsi
	mov 16, %rdx
	sub $8, %rsp
	call _memcpy
	add $8, %rsp
	add 16, %rsp
	push $3
	push $7
	lea cuber7_closure_data(%rip), %rdi
	lea 16(%rsp), %rsi
	mov 16, %rdx
	sub $8, %rsp
	call _memcpy
	add $8, %rsp
	add 16, %rsp
	sub $8, %rsp
	call identity7_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	sub $8, %rsp
	call squarer7_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	sub $8, %rsp
	call cuber7_fun
	add $8, %rsp
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	sub $8, %rsp
	call _printf
	add $8, %rsp
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

raise_exp_fun:
	push %rbp
	mov %rsp, %rbp
	push $1
	pop %rax
	mov %rax, ans_var(%rip)
	loop_0:
	push $0
	push 16(%rbp)
	pop %rcx
	pop %rax
	cmp %rax, %rcx
	mov $0, %rax
	seta %al
	push %rax
	pop %rax
	cmp $0, %rax
	je after0
	push ans_var(%rip)
	push 24(%rbp)
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	pop %rax
	mov %rax, ans_var(%rip)
	jmp loop_0
	after0:
	push ans_var(%rip)
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

cuber7_fun:
	push %rbp
	mov %rsp, %rbp
	sub 0, %rsp
	lea 0(%rsp), %rdi
	lea cuber7_closure_data(%rip), %rsi
	mov 0, %rdx
	call _memcpy
	call raise_exp_fun
	ret

squarer7_fun:
	push %rbp
	mov %rsp, %rbp
	sub 0, %rsp
	lea 0(%rsp), %rdi
	lea squarer7_closure_data(%rip), %rsi
	mov 0, %rdx
	call _memcpy
	call raise_exp_fun
	ret

identity7_fun:
	push %rbp
	mov %rsp, %rbp
	sub 0, %rsp
	lea 0(%rsp), %rdi
	lea identity7_closure_data(%rip), %rsi
	mov 0, %rdx
	call _memcpy
	call raise_exp_fun
	ret

cuber6_fun:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	sub 0, %rsp
	lea 0(%rsp), %rdi
	lea cuber6_closure_data(%rip), %rsi
	mov 0, %rdx
	call _memcpy
	call cuber_fun
	add $8, %rsp
	ret

squarer6_fun:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	sub 0, %rsp
	lea 0(%rsp), %rdi
	lea squarer6_closure_data(%rip), %rsi
	mov 0, %rdx
	call _memcpy
	call squarer_fun
	add $8, %rsp
	ret

identity6_fun:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	sub 0, %rsp
	lea 0(%rsp), %rdi
	lea identity6_closure_data(%rip), %rsi
	mov 0, %rdx
	call _memcpy
	call identity_fun
	add $8, %rsp
	ret

cuber_fun:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	sub 8, %rsp
	lea 8(%rsp), %rdi
	lea cuber_closure_data(%rip), %rsi
	mov 8, %rdx
	call _memcpy
	call raise_exp_fun
	add $8, %rsp
	ret

squarer_fun:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	sub 8, %rsp
	lea 8(%rsp), %rdi
	lea squarer_closure_data(%rip), %rsi
	mov 8, %rdx
	call _memcpy
	call raise_exp_fun
	add $8, %rsp
	ret

identity_fun:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	sub 8, %rsp
	lea 8(%rsp), %rdi
	lea identity_closure_data(%rip), %rsi
	mov 8, %rdx
	call _memcpy
	call raise_exp_fun
	add $8, %rsp
	ret

.data
	printf_format: .string "%d\n"
	scanf_format: .string "%d"
	ans_var: .quad 0
	cuber7_closure_data: .zero 16
	squarer7_closure_data: .zero 16
	identity7_closure_data: .zero 16
	cuber6_closure_data: .zero 8
	squarer6_closure_data: .zero 8
	identity6_closure_data: .zero 8
	cuber_closure_data: .zero 8
	squarer_closure_data: .zero 8
	identity_closure_data: .zero 8
