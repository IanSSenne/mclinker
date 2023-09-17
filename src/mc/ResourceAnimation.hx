package mc;

import haxe.Json;
import sys.io.File;
import haxe.io.Path;

class ResourceAnimation extends core.Resource {
	var commands:Array<String> = [];

	public function new(filePath:String) {
		var root = Path.normalize(Path.join([Paths.defaultBehaviorPack, 'animations']));
		var normalizedFileName = Path.normalize(filePath);

		while (root.charAt(0) == normalizedFileName.charAt(0)) {
			root = root.substr(1);
			normalizedFileName = normalizedFileName.substr(1);
		}
		super(Animation, normalizedFileName.substr(1));
		commands = [];
		var contents = File.getContent(filePath).split('\n').map(v -> v.split("//")[0]);
		commands = contents.filter(v -> StringTools.contains(v, "\"/"));
	}

	override function getCommands():Array<String> {
		return commands;
	}

	override function getReferenceString():Array<String> {
		return [];
	}
}
