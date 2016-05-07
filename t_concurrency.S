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
	push $48
	push $100
	lea c_100_48_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	push $49
	push $100
	lea c_100_49_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	push $50
	push $100
	lea c_100_50_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	push $51
	push $100
	lea c_100_51_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	push $52
	push $100
	lea c_100_52_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	push ans_c_100_48_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push ans_c_100_49_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push ans_c_100_50_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push ans_c_100_51_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push ans_c_100_52_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

factorial_fun:
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
	push 16(%rbp)
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

choose_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	call factorial_fun
	push %rax
	push 24(%rbp)
	call factorial_fun
	push %rax
	push 16(%rbp)
	push 24(%rbp)
	pop %rcx
	pop %rax
	sub %rcx, %rax
	push %rax
	call factorial_fun
	push %rax
	pop %rcx
	pop %rax
	mul %rcx
	push %rax
	pop %rcx
	pop %rax
	mov $0, %rdx
	div %rcx
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

c_100_52_fun:
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea c_100_52_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp choose_fun

c_100_51_fun:
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea c_100_51_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp choose_fun

c_100_50_fun:
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea c_100_50_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp choose_fun

c_100_49_fun:
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea c_100_49_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp choose_fun

c_100_48_fun:
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea c_100_48_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp choose_fun

.data
printf_format: .string "%d\n"
scanf_format: .string "%d"
ans_var: .quad 0
ans_c_100_52_var: .quad 0
ans_c_100_51_var: .quad 0
ans_c_100_50_var: .quad 0
ans_c_100_49_var: .quad 0
ans_c_100_48_var: .quad 0
c_100_52_closure_data: .zero 16
c_100_51_closure_data: .zero 16
c_100_50_closure_data: .zero 16
c_100_49_closure_data: .zero 16
c_100_48_closure_data: .zero 16
