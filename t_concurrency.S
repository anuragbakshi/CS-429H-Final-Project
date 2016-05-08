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
	push $1
	lea f_01_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $2
	lea f_02_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $3
	lea f_03_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $4
	lea f_04_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $5
	lea f_05_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $6
	lea f_06_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $7
	lea f_07_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $8
	lea f_08_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $9
	lea f_09_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $10
	lea f_10_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $11
	lea f_11_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $12
	lea f_12_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $13
	lea f_13_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $14
	lea f_14_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $15
	lea f_15_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $16
	lea f_16_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $17
	lea f_17_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $18
	lea f_18_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $19
	lea f_19_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	push $20
	lea f_20_closure_data(%rip), %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	call memcpy
	add $8, %rsp
	lea handle_f_01_var(%rip), %rdi
	mov $0, %rsi
	lea f_01_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_02_var(%rip), %rdi
	mov $0, %rsi
	lea f_02_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_03_var(%rip), %rdi
	mov $0, %rsi
	lea f_03_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_04_var(%rip), %rdi
	mov $0, %rsi
	lea f_04_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_05_var(%rip), %rdi
	mov $0, %rsi
	lea f_05_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_06_var(%rip), %rdi
	mov $0, %rsi
	lea f_06_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_07_var(%rip), %rdi
	mov $0, %rsi
	lea f_07_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_08_var(%rip), %rdi
	mov $0, %rsi
	lea f_08_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_09_var(%rip), %rdi
	mov $0, %rsi
	lea f_09_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_10_var(%rip), %rdi
	mov $0, %rsi
	lea f_10_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_11_var(%rip), %rdi
	mov $0, %rsi
	lea f_11_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_12_var(%rip), %rdi
	mov $0, %rsi
	lea f_12_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_13_var(%rip), %rdi
	mov $0, %rsi
	lea f_13_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_14_var(%rip), %rdi
	mov $0, %rsi
	lea f_14_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_15_var(%rip), %rdi
	mov $0, %rsi
	lea f_15_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_16_var(%rip), %rdi
	mov $0, %rsi
	lea f_16_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_17_var(%rip), %rdi
	mov $0, %rsi
	lea f_17_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_18_var(%rip), %rdi
	mov $0, %rsi
	lea f_18_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_19_var(%rip), %rdi
	mov $0, %rsi
	lea f_19_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	lea handle_f_20_var(%rip), %rdi
	mov $0, %rsi
	lea f_20_fun(%rip), %rdx
	mov $0, %rcx
	mov $0, %rax
	call pthread_create
	push handle_f_01_var(%rip)
	pop %rdi
	lea result_f_01_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_02_var(%rip)
	pop %rdi
	lea result_f_02_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_03_var(%rip)
	pop %rdi
	lea result_f_03_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_04_var(%rip)
	pop %rdi
	lea result_f_04_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_05_var(%rip)
	pop %rdi
	lea result_f_05_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_06_var(%rip)
	pop %rdi
	lea result_f_06_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_07_var(%rip)
	pop %rdi
	lea result_f_07_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_08_var(%rip)
	pop %rdi
	lea result_f_08_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_09_var(%rip)
	pop %rdi
	lea result_f_09_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_10_var(%rip)
	pop %rdi
	lea result_f_10_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_11_var(%rip)
	pop %rdi
	lea result_f_11_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_12_var(%rip)
	pop %rdi
	lea result_f_12_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_13_var(%rip)
	pop %rdi
	lea result_f_13_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_14_var(%rip)
	pop %rdi
	lea result_f_14_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_15_var(%rip)
	pop %rdi
	lea result_f_15_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_16_var(%rip)
	pop %rdi
	lea result_f_16_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_17_var(%rip)
	pop %rdi
	lea result_f_17_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_18_var(%rip)
	pop %rdi
	lea result_f_18_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_19_var(%rip)
	pop %rdi
	lea result_f_19_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push handle_f_20_var(%rip)
	pop %rdi
	lea result_f_20_var(%rip), %rsi
	mov $0, %rax
	call pthread_join
	push result_f_01_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_02_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_03_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_04_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_05_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_06_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_07_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_08_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_09_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_10_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_11_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_12_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_13_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_14_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_15_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_16_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_17_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_18_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_19_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push result_f_20_var(%rip)
	lea printf_format(%rip), %rdi
	pop %rsi
	mov $0, %rax
	call printf
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	pop %rcx
	add $0, %rsp
	push %rcx
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
	pop %rcx
	add $8, %rsp
	push %rcx
	ret
	push $0
	pop %rax
	mov %rbp, %rsp
	pop %rbp
	pop %rcx
	add $8, %rsp
	push %rcx
	ret

f_20_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_20_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_19_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_19_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_18_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_18_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_17_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_17_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_16_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_16_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_15_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_15_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_14_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_14_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_13_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_13_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_12_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_12_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_11_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_11_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_10_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_10_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_09_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_09_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_08_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_08_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_07_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_07_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_06_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_06_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_05_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_05_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_04_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_04_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_03_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_03_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_02_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_02_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

f_01_fun:
	pop %rax
	sub $8, %rsp
	push %rax
	lea 8(%rsp), %rdi
	lea f_01_closure_data(%rip), %rsi
	mov $8, %rdx
	call memcpy
	jmp factorial_fun

.data
printf_format: .string "%d\n"
scanf_format: .string "%d"
ans_var: .quad 0
result_f_20_var: .quad 0
result_f_19_var: .quad 0
result_f_18_var: .quad 0
result_f_17_var: .quad 0
result_f_16_var: .quad 0
result_f_15_var: .quad 0
result_f_14_var: .quad 0
result_f_13_var: .quad 0
result_f_12_var: .quad 0
result_f_11_var: .quad 0
result_f_10_var: .quad 0
result_f_09_var: .quad 0
result_f_08_var: .quad 0
result_f_07_var: .quad 0
result_f_06_var: .quad 0
result_f_05_var: .quad 0
result_f_04_var: .quad 0
result_f_03_var: .quad 0
result_f_02_var: .quad 0
result_f_01_var: .quad 0
handle_f_20_var: .quad 0
handle_f_19_var: .quad 0
handle_f_18_var: .quad 0
handle_f_17_var: .quad 0
handle_f_16_var: .quad 0
handle_f_15_var: .quad 0
handle_f_14_var: .quad 0
handle_f_13_var: .quad 0
handle_f_12_var: .quad 0
handle_f_11_var: .quad 0
handle_f_10_var: .quad 0
handle_f_09_var: .quad 0
handle_f_08_var: .quad 0
handle_f_07_var: .quad 0
handle_f_06_var: .quad 0
handle_f_05_var: .quad 0
handle_f_04_var: .quad 0
handle_f_03_var: .quad 0
handle_f_02_var: .quad 0
handle_f_01_var: .quad 0
f_20_closure_data: .zero 8
f_19_closure_data: .zero 8
f_18_closure_data: .zero 8
f_17_closure_data: .zero 8
f_16_closure_data: .zero 8
f_15_closure_data: .zero 8
f_14_closure_data: .zero 8
f_13_closure_data: .zero 8
f_12_closure_data: .zero 8
f_11_closure_data: .zero 8
f_10_closure_data: .zero 8
f_09_closure_data: .zero 8
f_08_closure_data: .zero 8
f_07_closure_data: .zero 8
f_06_closure_data: .zero 8
f_05_closure_data: .zero 8
f_04_closure_data: .zero 8
f_03_closure_data: .zero 8
f_02_closure_data: .zero 8
f_01_closure_data: .zero 8
