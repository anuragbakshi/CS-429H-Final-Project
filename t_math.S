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

main_fun:
	mflr 15
	push 15
	push 2
	mr 2, 1
	# load immediate 0x64
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x64
	push 15
	pop 25
	std 25, 8(6)
	# load immediate 0x14
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x14
	push 15
	pop 25
	std 25, 16(6)
	# load global a
	ld 15, 8(6)
	push 15
	# load global b
	ld 15, 16(6)
	push 15
	# +
	pop 26
	pop 25
	add 25, 25, 26
	push 25
	pop 25
	std 25, 24(6)
	# load global a
	ld 15, 8(6)
	push 15
	# load global b
	ld 15, 16(6)
	push 15
	# -
	pop 26
	pop 25
	sub 25, 25, 26
	push 25
	pop 25
	std 25, 32(6)
	# load global a
	ld 15, 8(6)
	push 15
	# load global b
	ld 15, 16(6)
	push 15
	# *
	pop 26
	pop 25
	mulld 25, 25, 26
	push 25
	pop 25
	std 25, 40(6)
	# load global a
	ld 15, 8(6)
	push 15
	# load global b
	ld 15, 16(6)
	push 15
	# /
	pop 26
	pop 25
	divd 25, 25, 26
	push 25
	pop 25
	std 25, 48(6)
	# load global add
	ld 15, 24(6)
	push 15
	pop 15
	bl print
	# load global sub
	ld 15, 32(6)
	push 15
	pop 15
	bl print
	# load global mul
	ld 15, 40(6)
	push 15
	pop 15
	bl print
	# load global div
	ld 15, 48(6)
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

.data
.fill 8192
stack_base:
data: .fill 48

.global entry
entry:
	.quad main
	.quad data
	.quad 0

