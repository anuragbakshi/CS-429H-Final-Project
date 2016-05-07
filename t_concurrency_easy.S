.text
	.global main
	.extern printf
	.extern scanf
	.extern memcpy
	.extern pthread_create
	.extern pthread_join

main:
	jmp main_fun

main_fun:
	push %rbp
	mov %rsp, %rbp
	push $5
	push $3
	lea mult_3_5_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	push $7
	push $3
	lea mult_3_7_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	push $11
	push $3
	lea mult_3_11_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	push $13
	push $3
	lea mult_3_13_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	push $17
	push $3
	lea mult_3_17_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $16, %rdx
	call memcpy
	add $16, %rsp
	lea handle_mult_3_5_var(%rip), %rdi
	mov $0, %rsi
	lea mult_3_5_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_mult_3_7_var(%rip), %rdi
	mov $0, %rsi
	lea mult_3_7_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_mult_3_11_var(%rip), %rdi
	mov $0, %rsi
	lea mult_3_11_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_mult_3_13_var(%rip), %rdi
	mov $0, %rsi
	lea mult_3_13_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_mult_3_17_var(%rip), %rdi
	mov $0, %rsi
	lea mult_3_17_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	push handle_mult_3_5_var(%rip)
	pop %rdi
	lea ans_mult_3_5_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_mult_3_7_var(%rip)
	pop %rdi
	lea ans_mult_3_7_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_mult_3_11_var(%rip)
	pop %rdi
	lea ans_mult_3_11_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_mult_3_13_var(%rip)
	pop %rdi
	lea ans_mult_3_13_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_mult_3_17_var(%rip)
	pop %rdi
	lea ans_mult_3_17_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push ans_mult_3_5_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push ans_mult_3_7_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push ans_mult_3_11_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push ans_mult_3_13_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push ans_mult_3_17_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	ret

multiply_fun:
	push %rbp
	mov %rsp, %rbp
	push 16(%rbp)
	push 24(%rbp)
	pop %rcx
	pop %rax
	mul %rcx
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

mult_3_17_fun:
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea mult_3_17_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp multiply_fun

mult_3_13_fun:
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea mult_3_13_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp multiply_fun

mult_3_11_fun:
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea mult_3_11_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp multiply_fun

mult_3_7_fun:
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea mult_3_7_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp multiply_fun

mult_3_5_fun:
	pop %rbx
	sub $16, %rsp
	mov %rsp, %rdi
	lea mult_3_5_closure_data(%rip), %rsi
	mov $16, %rdx
	call memcpy
	push %rbx
	jmp multiply_fun

.data
printf_format: .string "%d\n"
scanf_format: .string "%d"
ans_mult_3_17_var: .quad 0
ans_mult_3_13_var: .quad 0
ans_mult_3_11_var: .quad 0
ans_mult_3_7_var: .quad 0
ans_mult_3_5_var: .quad 0
handle_mult_3_17_var: .quad 0
handle_mult_3_13_var: .quad 0
handle_mult_3_11_var: .quad 0
handle_mult_3_7_var: .quad 0
handle_mult_3_5_var: .quad 0
mult_3_17_closure_data: .zero 16
mult_3_13_closure_data: .zero 16
mult_3_11_closure_data: .zero 16
mult_3_7_closure_data: .zero 16
mult_3_5_closure_data: .zero 16
