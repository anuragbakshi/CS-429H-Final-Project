fun main() {
	bind c_100_48, choose, (100, 48)
	bind c_100_49, choose, (100, 49)
	bind c_100_50, choose, (100, 50)
	bind c_100_51, choose, (100, 51)
	bind c_100_52, choose, (100, 52)

	async handle_c_100_48, c_100_48
	async handle_c_100_49, c_100_49
	async handle_c_100_50, c_100_50
	async handle_c_100_51, c_100_51
	async handle_c_100_52, c_100_52

	await ans_c_100_48, handle_c_100_48
	await ans_c_100_49, handle_c_100_49
	await ans_c_100_50, handle_c_100_50
	await ans_c_100_51, handle_c_100_51
	await ans_c_100_52, handle_c_100_52

	print ans_c_100_48
	print ans_c_100_49
	print ans_c_100_50
	print ans_c_100_51
	print ans_c_100_52
}

fun factorial(n) {
	ans = 1
	while(n > 0) {
		ans = ans * n;
		n = n - 1;
	}

	return ans
}

fun choose(n, k) {
	return factorial(n) / (factorial(k) * factorial(n - k))
}
