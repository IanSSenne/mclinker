package mc;

import sys.io.File;
import haxe.io.Path;

class ResourceScript extends core.Resource {
	var commands:Array<String> = [];

	public function new(filePath:String) {
		var root = Path.normalize(Path.join([Sys.getCwd(), 'src']));
		var normalizedFileName = Path.normalize(filePath);

		while (root.charAt(0) == normalizedFileName.charAt(0)) {
			root = root.substr(1);
			normalizedFileName = normalizedFileName.substr(1);
		}
		super(Script, normalizedFileName.substr(1));
		var contents = File.getContent(filePath).split('\n');

		for (line in contents) {
			if (StringTools.trim(line) == '') {
				continue;
			}
			commands.push(StringTools.trim(line));
		}
	}

	override function getCommands():Array<String> {
		return commands;
	}

	override function getReferenceString():Array<String> {
		return [];
	}
}
