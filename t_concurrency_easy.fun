fun main() {
	bind show1, show, (1)

	async handle_show1, show1
	await x, handle_show1

	async handle_show_const, show_const
	await x, handle_show_const
}

fun show(a) {
	print a
}

fun show_const() {
	print 100
}
