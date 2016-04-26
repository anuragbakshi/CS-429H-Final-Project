package cs429hpd;

public class Entry {
	public static void main(String[] args) {
		String src = args[0];
		if(src != null);
		ParseTree parseTree = new ParseTree(src);
		Optimizer optimizer = new Optimizer(parseTree);
		System.out.println(optimizer);
	}
}
