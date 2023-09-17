@:cppInclude("windows.h")
class Console {
	public static function getConsoleSize() {
		var cols:Int = -1;
		var rows:Int = -1;
		untyped __cpp__('CONSOLE_SCREEN_BUFFER_INFO csbi;
		GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);
		{0} = csbi.srWindow.Right - csbi.srWindow.Left + 1;
		{1} = csbi.srWindow.Bottom - csbi.srWindow.Top + 1;', cols, rows);
		return {
			cols: cols,
			rows: rows
		};
	}
}
