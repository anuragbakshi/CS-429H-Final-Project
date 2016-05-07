.text
	.global main
	.extern printf
	.extern scanf
	.extern memcpy

main:
	jmp main_fun

.data
printf_format: .string "%d\n"
scanf_format: .string "%d"
