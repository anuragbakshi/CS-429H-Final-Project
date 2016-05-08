fun main() {
	bind f_01, factorial, (01)
	bind f_02, factorial, (02)
	bind f_03, factorial, (03)
	bind f_04, factorial, (04)
	bind f_05, factorial, (05)
	bind f_06, factorial, (06)
	bind f_07, factorial, (07)
	bind f_08, factorial, (08)
	bind f_09, factorial, (09)
	bind f_10, factorial, (10)
	bind f_11, factorial, (11)
	bind f_12, factorial, (12)
	bind f_13, factorial, (13)
	bind f_14, factorial, (14)
	bind f_15, factorial, (15)
	bind f_16, factorial, (16)
	bind f_17, factorial, (17)
	bind f_18, factorial, (18)
	bind f_19, factorial, (19)
	bind f_20, factorial, (20)

	async handle_f_01, f_01
	async handle_f_02, f_02
	async handle_f_03, f_03
	async handle_f_04, f_04
	async handle_f_05, f_05
	async handle_f_06, f_06
	async handle_f_07, f_07
	async handle_f_08, f_08
	async handle_f_09, f_09
	async handle_f_10, f_10
	async handle_f_11, f_11
	async handle_f_12, f_12

	await result_f_01, handle_f_01
	await result_f_02, handle_f_02
	await result_f_03, handle_f_03
	await result_f_04, handle_f_04
	await result_f_05, handle_f_05
	await result_f_06, handle_f_06
	await result_f_07, handle_f_07
	await result_f_08, handle_f_08
	await result_f_09, handle_f_09
	await result_f_10, handle_f_10
	await result_f_11, handle_f_11
	await result_f_12, handle_f_12

	print result_f_01
	print result_f_02
	print result_f_03
	print result_f_04
	print result_f_05
	print result_f_06
	print result_f_07
	print result_f_08
	print result_f_09
	print result_f_10
	print result_f_11
	print result_f_12

	x = threaded_print(1)
	x = threaded_print(2)
	x = threaded_print(3)
	x = threaded_print(4)

	i = 0
	while(i < 100) {
		bind n_sum_const, n_sum, (i)

		async handle_n_sum, n_sum_const
		await n_sum_val, handle_n_sum

		print n_sum_val

		i = i + 1
	}

	x = threaded_recursion(100)
}

fun factorial(n) {
	ans = 1
	while(n > 0) {
		ans = ans * n;
		n = n - 1;
	}

	return ans
}

fun n_sum(n) {
	return (n * (n + 1)) / 2
}

fun print_fun(n) {
	print n
	return n
}

fun threaded_print(n) {
	bind print_const, print_fun, (n)

	async handle_threaded_print, print_const
	await printed_val, handle_threaded_print

	print printed_val
}

fun threaded_recursion(n) {
	if(n > 0) {
		x = threaded_print(n)
		x = threaded_recursion(n - 1)
	}
}
