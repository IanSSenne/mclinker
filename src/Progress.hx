class ProgressBar {
	var max:Int;
	var consoleSize:{cols:Int, rows:Int} = Console.getConsoleSize();

	public function new(max:Int) {
		this.max = max;
		trace(Console.getConsoleSize());
		Sys.print(EscapeCodes.privateModes.INVISIBLE_CURSOR + EscapeCodes.erase.DISPLAY);
	}

	public function update(value:Int) {
		var percent:Float = value / max;
		var barWidth:Int = consoleSize.cols - 7;
		var barSize:Int = Math.round(percent * barWidth);
		var bar:String = "";
		for (i in 0...barSize) {
			bar += "=";
		}
		var spaceSize:Int = barWidth - barSize;
		var space:String = "";
		for (i in 0...spaceSize) {
			space += " ";
		}
		var content = "[" + bar + space + "] " + StringTools.rpad("0", Std.string(Math.round(percent * 100)), 3) + "%";
		Sys.print(content + EscapeCodes.cursor.GOTO(0, 0));
	}
}
