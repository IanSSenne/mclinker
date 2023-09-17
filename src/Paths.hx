package;

import sys.FileSystem;
import haxe.io.Path;

class Paths {
	public static var behaviorPacksFolder = Path.join([Sys.getCwd(), "behavior_packs"]);
	public static var resourcePacksFolder = Path.join([Sys.getCwd(), "resource_packs"]);
	public static var behaviorPacksList = FileSystem.readDirectory(behaviorPacksFolder);
	public static var resourcePacksList = FileSystem.readDirectory(resourcePacksFolder);
	public static var hasMultipleBehaviorPacks = behaviorPacksList.length > 1;
	public static var hasMultipleResourcePacks = resourcePacksList.length > 1;
	public static var defaultBehaviorPack = Path.join([Paths.behaviorPacksFolder, behaviorPacksList[0]]);
	public static var defaultResourcePack = Path.join([Paths.resourcePacksFolder, resourcePacksList[0]]);

	public static function getBehaviorPackPath(index:Int):String {
		return Path.join([behaviorPacksFolder, behaviorPacksList[index]]);
	}

	public static function getResourcePackPath(index:Int):String {
		return Path.join([resourcePacksFolder, resourcePacksList[index]]);
	}
}
