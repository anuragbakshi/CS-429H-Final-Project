fun main() {
	bind show1, show, (1)

	async handle_show1, show1
	await x, handle_show1

	x = show(2)
}

fun show(a) {
	print a
}

fun show_const() {
	print 100
}
