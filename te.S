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

f4_fun:
	mflr 15
	push 15
	push 2
	mr 2, 1
	# load local a
	ld 15, 16(2)
	push 15
	# load local b
	ld 15, 24(2)
	push 15
	# load local c
	ld 15, 32(2)
	push 15
	# load local d
	ld 15, 40(2)
	push 15
	# +
	pop 25
	pop 26
	add 25, 25, 26
	push 25
	# +
	pop 25
	pop 26
	add 25, 25, 26
	push 25
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

f3_fun:
	mflr 15
	push 15
	push 2
	mr 2, 1
	# load local a
	ld 15, 16(2)
	push 15
	# load local b
	ld 15, 24(2)
	push 15
	# load local c
	ld 15, 32(2)
	push 15
	# +
	pop 25
	pop 26
	add 25, 25, 26
	push 25
	# +
	pop 25
	pop 26
	add 25, 25, 26
	push 25
	pop 15
	bl print
	# f4(...)
	# load local c
	ld 15, 32(2)
	push 15
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# +
	pop 25
	pop 26
	add 25, 25, 26
	push 25
	# load local c
	ld 15, 32(2)
	push 15
	# load local b
	ld 15, 24(2)
	push 15
	# load local a
	ld 15, 16(2)
	push 15
	bl f4_fun
	push 25
	pop 25
	std 25, 8(6)
	# load local a
	ld 15, 16(2)
	push 15
	# load local b
	ld 15, 24(2)
	push 15
	# load local c
	ld 15, 32(2)
	push 15
	# +
	pop 25
	pop 26
	add 25, 25, 26
	push 25
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

f2_fun:
	mflr 15
	push 15
	push 2
	mr 2, 1
	# load local a
	ld 15, 16(2)
	push 15
	# load local b
	ld 15, 24(2)
	push 15
	# +
	pop 25
	pop 26
	add 25, 25, 26
	push 25
	pop 15
	bl print
	# f3(...)
	# load local b
	ld 15, 24(2)
	push 15
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# +
	pop 25
	pop 26
	add 25, 25, 26
	push 25
	# load local b
	ld 15, 24(2)
	push 15
	# load local a
	ld 15, 16(2)
	push 15
	bl f3_fun
	push 25
	pop 25
	std 25, 8(6)
	# load local a
	ld 15, 16(2)
	push 15
	# load local b
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

f1_fun:
	mflr 15
	push 15
	push 2
	mr 2, 1
	# load local a
	ld 15, 16(2)
	push 15
	pop 15
	bl print
	# f2(...)
	# load local a
	ld 15, 16(2)
	push 15
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# +
	pop 25
	pop 26
	add 25, 25, 26
	push 25
	# load local a
	ld 15, 16(2)
	push 15
	bl f2_fun
	push 25
	pop 25
	std 25, 8(6)
	# load local a
	ld 15, 16(2)
	push 15
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

main_fun:
	mflr 15
	push 15
	push 2
	mr 2, 1
	# f1(...)
	# load immediate 0x2
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x2
	push 15
	bl f1_fun
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

