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
	push $1
	lea identity_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $2
	lea squarer_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $3
	lea cuber_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $5
	call identity_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $5
	call squarer_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $5
	call cuber_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $6
	lea identity6_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $6
	lea squarer6_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $6
	lea cuber6_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	call identity6_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	call squarer6_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	call cuber6_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $7
	push $1
	lea identity7_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	push $7
	push $2
	lea squarer7_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	push $7
	push $3
	lea cuber7_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	call identity7_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	call squarer7_fun
	push %rax
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	call cuber7_fun
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
	push 16(%rbp)
	push $1
	pop %rcx
	pop %rax
	sub %rcx, %rax
	push %rax
	pop %rax
	mov %rax, 16(%rbp)
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
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea cuber7_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp raise_exp_fun

squarer7_fun:
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea squarer7_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp raise_exp_fun

identity7_fun:
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea identity7_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp raise_exp_fun

cuber6_fun:
	pop %rbx
	sub $8, %rsp
	mov %rsp, %rdi
	lea cuber6_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	push %rbx
	jmp cuber_fun

squarer6_fun:
	pop %rbx
	sub $8, %rsp
	mov %rsp, %rdi
	lea squarer6_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	push %rbx
	jmp squarer_fun

identity6_fun:
	pop %rbx
	sub $8, %rsp
	mov %rsp, %rdi
	lea identity6_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	push %rbx
	jmp identity_fun

cuber_fun:
	pop %rbx
	sub $8, %rsp
	mov %rsp, %rdi
	lea cuber_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	push %rbx
	jmp raise_exp_fun

squarer_fun:
	pop %rbx
	sub $8, %rsp
	mov %rsp, %rdi
	lea squarer_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	push %rbx
	jmp raise_exp_fun

identity_fun:
	pop %rbx
	sub $8, %rsp
	mov %rsp, %rdi
	lea identity_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	push %rbx
	jmp raise_exp_fun

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
