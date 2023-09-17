package mc;

import sys.FileSystem;
import sys.io.File;
import haxe.Json;
import haxe.io.Path;
import core.Resource;

class ResourceFunctionTag extends Resource {
	var commands:Array<String> = [];

	public function new(file:String) {
		var root = Path.normalize(Path.join([Paths.defaultBehaviorPack, 'functions']));
		var normalizedFileName = Path.normalize(file);
		while (root.charAt(0) == normalizedFileName.charAt(0)) {
			root = root.substr(1);
			normalizedFileName = normalizedFileName.substr(1);
		}
		super(FunctionTag, Path.withoutExtension(normalizedFileName.substr(1)));
		commands = Json.parse(File.getContent(file)).values;
	}

	override function getCommands():Array<String> {
		return commands;
	}

	override function getReferenceString():Array<String> {
		return [];
	}
}
