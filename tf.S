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
	# load immediate 0xa
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0xa
	push 15
	pop 15
	bl print
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# ==
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 29
	andi. 25, 25, 1
	push 25
	pop 15
	bl print
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# !=
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 29
	andi. 25, 25, 1
	xori 25, 25, 1
	push 25
	pop 15
	bl print
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# <
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 31
	andi. 25, 25, 1
	push 25
	pop 15
	bl print
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# >
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 30
	andi. 25, 25, 1
	push 25
	pop 15
	bl print
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# load immediate 0x2
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x2
	push 15
	# ==
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 29
	andi. 25, 25, 1
	push 25
	pop 15
	bl print
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# load immediate 0x2
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x2
	push 15
	# !=
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 29
	andi. 25, 25, 1
	xori 25, 25, 1
	push 25
	pop 15
	bl print
	# load immediate 0x2
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x2
	push 15
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# <
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 31
	andi. 25, 25, 1
	push 25
	pop 15
	bl print
	# load immediate 0x2
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x2
	push 15
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# >
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 30
	andi. 25, 25, 1
	push 25
	pop 15
	bl print
	# load immediate 0x2
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x2
	push 15
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# ==
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 29
	andi. 25, 25, 1
	push 25
	pop 15
	bl print
	# load immediate 0x2
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x2
	push 15
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# !=
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 29
	andi. 25, 25, 1
	xori 25, 25, 1
	push 25
	pop 15
	bl print
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# load immediate 0x2
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x2
	push 15
	# <
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 31
	andi. 25, 25, 1
	push 25
	pop 15
	bl print
	# load immediate 0x1
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x1
	push 15
	# load immediate 0x2
	xor 15, 15, 15
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	oris 15, 15, 0x0
	ori 15, 15, 0x2
	push 15
	# >
	pop 25
	pop 26
	cmpd 25, 26
	mfcr 25
	srdi 25, 25, 30
	andi. 25, 25, 1
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

.data
.fill 8192
stack_base:
data: .fill 0

.global entry
entry:
	.quad main
	.quad data
	.quad 0

