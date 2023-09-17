package mc;

import sys.io.File;
import haxe.io.Path;

class ResourceFunction extends core.Resource {
	var commands:Array<String> = [];

	public function new(filePath:String) {
		var root = Path.normalize(Path.join([Paths.defaultBehaviorPack, 'functions']));
		var normalizedFileName = Path.normalize(filePath);

		while (root.charAt(0) == normalizedFileName.charAt(0)) {
			root = root.substr(1);
			normalizedFileName = normalizedFileName.substr(1);
		}
		super(Function, Path.withoutExtension(normalizedFileName.substr(1)));
		var contents = File.getContent(filePath).split('\n');

		for (line in contents) {
			if (line.charAt(0) == '#' || StringTools.trim(line) == '') {
				continue;
			}
			commands.push(StringTools.trim(line));
		}
	}

	override function getCommands():Array<String> {
		return commands;
	}

	override function getReferenceString():Array<String> {
		return [id];
	}
}
