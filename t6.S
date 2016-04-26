.macro push reg
	addi 1, 1, -8
	std \reg, 0(1)
.endm
.macro pop reg
	ld \reg, 0(1)
	addi 1, 1, 8
.endm
.global main

main:
	mr 6, 2
	addi 2, 2, -8
	mr 1, 2
	bl main_fun
	mr 6, 25
	b exit

b_fun:
	mflr 15
	push 15
	push 2
	mr 2, 1
	# load local x
	ld 15, 16(2)
	push 15
	# load local y
	ld 15, 24(2)
	push 15
	# +
	pop 25
	pop 26
	add 25, 25, 26
	push 25
	pop 15
	bl print
	# load immediate 0x0
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x0
	push 15
	pop 25
	mr 1, 2
	pop 2
	pop 15
	mtlr 15
	blr

c_fun:
	mflr 15
	push 15
	push 2
	mr 2, 1
	# load local x
	ld 15, 16(2)
	push 15
	# load local y
	ld 15, 24(2)
	push 15
	# *
	pop 25
	pop 26
	mulld 25, 25, 26
	push 25
	pop 15
	bl print
	# load immediate 0x0
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x0
	push 15
	pop 25
	mr 1, 2
	pop 2
	pop 15
	mtlr 15
	blr

a_fun:
	mflr 15
	push 15
	push 2
	mr 2, 1
	# if
	# load local y
	ld 15, 24(2)
	push 15
	# load local x
	ld 15, 16(2)
	push 15
	# >
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 30
	andi. 25, 25, 1
	push 25
	pop 25
	cmpdi 25, 0
	beq else_0
	# b(...)
	# load local y
	ld 15, 24(2)
	push 15
	# load local x
	ld 15, 16(2)
	push 15
	bl b_fun
	push 25
	pop 25
	std 25, 8(6)
	b after_0
	# else
	else_0:
	# c(...)
	# load local y
	ld 15, 24(2)
	push 15
	# load local x
	ld 15, 16(2)
	push 15
	bl c_fun
	push 25
	pop 25
	std 25, 8(6)
	# endif
	after_0:
	# load immediate 0x0
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x0
	push 15
	pop 25
	mr 1, 2
	pop 2
	pop 15
	mtlr 15
	blr

main_fun:
	mflr 15
	push 15
	push 2
	mr 2, 1
	# a(...)
	# load immediate 0x14
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x14
	push 15
	# load immediate 0xa
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0xa
	push 15
	bl a_fun
	push 25
	pop 25
	std 25, 8(6)
	# a(...)
	# load immediate 0xa
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0xa
	push 15
	# load immediate 0x14
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x14
	push 15
	bl a_fun
	push 25
	pop 25
	std 25, 8(6)
	# load immediate 0x0
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x0
	push 15
	pop 25
	mr 1, 2
	pop 2
	pop 15
	mtlr 15
	blr

.data
.fill 8192
stack_base:
data: .fill 8

.global entry
entry:
	.quad main
	.quad data
	.quad 0

