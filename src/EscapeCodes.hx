package;

class EscapeCodes {
	private static final ESC = String.fromCharCode(0x1B);
	private static final CSI = String.fromCharCode(0x9B);
	private static final DCS = String.fromCharCode(0x90);
	private static final OSC = String.fromCharCode(0x9D);

	public static final general = {
		BEL: ESC + String.fromCharCode(0x07),
		BS: ESC + String.fromCharCode(0x08),
		HT: ESC + String.fromCharCode(0x09),
		LF: ESC + String.fromCharCode(0x0A),
		VT: ESC + String.fromCharCode(0x0B),
		FF: ESC + String.fromCharCode(0x0C),
		CR: ESC + String.fromCharCode(0x0D),
	};

	public static final cursor = {
		HOME: ESC + "[H",
		GOTO: (col:Int, row:Int) -> ESC + "[" + row + ";" + col + "f",
		UP: (n) -> ESC + "[" + n + "A",
		DOWN: (n) -> ESC + "[" + n + "B",
		RIGHT: (n) -> ESC + "[" + n + "C",
		LEFT: (n) -> ESC + "[" + n + "D",
		SAVE: ESC + "7",
	}

	public static final erase = {
		SCREEN: ESC + "[2J",
		DISPLAY: ESC + "[K",
		LINE: ESC + "[2K",
	}

	public static final scroll = {
		UP: ESC + "D",
		DOWN: ESC + "M",
	}

	public static final colors = {
		RESET: ESC + "[0m",
		BOLD: ESC + "[1m",
		DIM: ESC + "[2m",
		ITALIC: ESC + "[3m",
		UNDERLINE: ESC + "[4m",
		BLINK: ESC + "[5m",
		INVERT: ESC + "[7m",
		HIDDEN: ESC + "[8m",
		STRIKE: ESC + "[9m",
		FG_IDX: (n) -> ESC + "[38;5;" + n + "m",
		BG_IDX: (n) -> ESC + "[48;5;" + n + "m",
	}

	public static final cursorStyle = {
		BLINKING_BLOCK: ESC + "[0 q",
		BLOCK: ESC + "[1 q",
		UNDERLINE: ESC + "[2 q",
		BEAM: ESC + "[3 q",
	}

	public static final privateModes = {
		INVISIBLE_CURSOR: ESC + "[?25l",
		VISIBLE_CURSOR: ESC + "[?25h",
		SAVE_SCREEN: ESC + "[?47h",
		RESTORE_SCREEN: ESC + "[?47l",
		ENABLE_ALT_BUFFER: ESC + "[?1049h",
		DISABLE_ALT_BUFFER: ESC + "[?1049l",
	}
}
