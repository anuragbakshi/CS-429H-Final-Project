fun main() {
	bind mult_3_5, multiply, (3, 5)
	bind mult_3_7, multiply, (3, 7)
	bind mult_3_11, multiply, (3, 11)
	bind mult_3_13, multiply, (3, 13)
	bind mult_3_17, multiply, (3, 17)

	async handle_mult_3_5, mult_3_5
	async handle_mult_3_7, mult_3_7
	async handle_mult_3_11, mult_3_11
	async handle_mult_3_13, mult_3_13
	async handle_mult_3_17, mult_3_17

	await ans_mult_3_5, handle_mult_3_5
	await ans_mult_3_7, handle_mult_3_7
	await ans_mult_3_11, handle_mult_3_11
	await ans_mult_3_13, handle_mult_3_13
	await ans_mult_3_17, handle_mult_3_17

	print ans_mult_3_5
	print ans_mult_3_7
	print ans_mult_3_11
	print ans_mult_3_13
	print ans_mult_3_17
}

fun multiply(a, b) {
	return a * b
}
