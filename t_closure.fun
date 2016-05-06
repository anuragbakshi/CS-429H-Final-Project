fun main() {
	bind identity, raise_exp, (1)
	bind squarer, raise_exp, (2)
	bind cuber, raise_exp, (3)

	print identity(5)
	print squarer(5)
	print cuber(5)

	bind identity6, identity, (6)
	bind squarer6, squarer, (6)
	bind cuber6, cuber, (6)

	print identity6()
	print squarer6()
	print cuber6()

	bind identity7, raise_exp, (1, 7)
	bind squarer7, raise_exp, (2, 7)
	bind cuber7, raise_exp, (3, 7)

	print identity7()
	print squarer7()
	print cuber7()
}

fun raise_exp(exp, base) {
	ans = 1
	while(exp > 0) {
		ans = ans * base
		exp = exp - 1
	}

	return ans
}
