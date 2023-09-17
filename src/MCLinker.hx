package;

import Progress.ProgressBar;
import sys.io.Process;
import haxe.Timer;
import hx_webserver.HTTPServer;
import sys.net.Host;
import haxe.io.BytesInput;
import haxe.zip.Reader;
import haxe.Resource;
import mc.ResourceDialog;
import mc.ResourceAnimationController;
import mc.ResourceAnimation;
import mc.ResourceScript;
import mc.ResourceFunctionTag;
import haxe.Json;
import sys.io.File;
import mc.ResourceFunction;
import haxe.io.Path;
import core.FsUtil;

class MCLinker {
	static function main() {
		var functionFiles = FsUtil.getFilesInDir(Path.join([Paths.defaultBehaviorPack, "functions"]));
		var animations = FsUtil.getFilesInDir(Path.join([Paths.defaultBehaviorPack, "animations"]));
		var animationControllers = FsUtil.getFilesInDir(Path.join([Paths.defaultBehaviorPack, "animation_controllers"]));
		var scriptFiles = FsUtil.getFilesInDir(Path.join([Sys.getCwd(), "src"]));
		var dialogFiles = FsUtil.getFilesInDir(Path.join([Paths.defaultBehaviorPack, "dialogue"]));
		var resources:Map<String, core.Resource> = new Map<String, core.Resource>();
		var p = new ProgressBar(functionFiles.length + scriptFiles.length + animations.length + animationControllers.length + dialogFiles.length);
		// Sys.print(EscapeCodes.erase.SCREEN);
		var count = 0;
		for (file in functionFiles) {
			if (StringTools.endsWith(file, ".mcfunction")) {
				var inst = new ResourceFunction(file);
				resources.set(inst.getId(), inst);
			} else if (StringTools.endsWith(file, ".json")) {
				var inst = new ResourceFunctionTag(file);
				resources.set(inst.getId(), inst);
			}
			count++;
			p.update(count);
		}

		for (file in scriptFiles) {
			if (StringTools.endsWith(file, ".ts")) {
				var inst = new ResourceScript(file);
				resources.set(inst.getId(), inst);
			}
			count++;
			p.update(count);
		}
		for (file in animations) {
			if (StringTools.endsWith(file, ".json")) {
				var inst = new ResourceAnimation(file);
				resources.set(inst.getId(), inst);
			}
			count++;
			p.update(count);
		}
		for (file in animationControllers) {
			if (StringTools.endsWith(file, ".json")) {
				var inst = new ResourceAnimationController(file);
				resources.set(inst.getId(), inst);
			}
			count++;
			p.update(count);
		}
		for (file in dialogFiles) {
			if (StringTools.endsWith(file, ".json")) {
				var inst = new ResourceDialog(file);
				resources.set(inst.getId(), inst);
			}
			count++;
			p.update(count);
		}
		trace("Finding references...");
		var references = new Map<String, Array<String>>();
		var referenced = [
			for (resource in resources)
				resource.getId() => false
		];
		p = new ProgressBar([for (k in resources.keys()) k].length);
		var index = 0;
		for (id => value in resources) {
			var refs = new Map<String, Bool>();
			var checkValues = value.getReferenceString();
			for (otherId => otherValue in resources) {
				var commands = otherValue.getCommands();
				for (command in commands)
					for (check in checkValues)
						if (StringTools.contains(command, check)) {
							refs.set(otherId, true);
							referenced.set(otherId, true);
						}
			}
			references.set(id, [for (k => v in refs) k]);
			index++;
			p.update(index);
		}
		trace("Done!");

		if (Sys.args().indexOf("--report") > -1) {
			File.saveContent(Path.join([Sys.getCwd(), "report.json"]), Json.stringify({
				references: references,
				referenceMap: referenced
			}, null, "  "));
		} else {
			trace("loading viewer");
			var viewer = Resource.getBytes("viewer");
			var entries = Reader.readZip(new BytesInput(viewer));
			var files:Map<String, String> = new Map<String, String>();
			for (entry in entries) {
				files.set(Path.normalize(entry.fileName.substr(4)), Reader.unzip(entry).toString());
			}
			trace("starting server");
			new WebApp(files, Json.stringify({
				references: references,
				referenceMap: referenced
			}));
			trace("opening browser");
			Sys.command("start http://localhost:8080");
		}
		// var sock = new HTTPServer(Host.localhost(), 8080, true);
		// trace(sock.server.host());
		// // sock.onClientConnect = (req) -> {
		// // 	trace(req);

		// // 	req.replyData(files.get(""), "text/html");
		// // };
	}
}
