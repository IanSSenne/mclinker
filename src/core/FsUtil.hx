package core;

import haxe.io.Path;
import sys.FileSystem;

class FsUtil {
	public static function getFilesInDir(dir:String):Array<String> {
		if (FileSystem.exists(dir) == false)
			return [];
		var files = FileSystem.readDirectory(dir);
		var results:Array<String> = [];

		for (file in files) {
			if (FileSystem.isDirectory(Path.join([dir, file]))) {
				results = results.concat(getFilesInDir(Path.join([dir, file])));
			} else {
				results.push(Path.join([dir, file]));
			}
		}

		return results;
	}
}
