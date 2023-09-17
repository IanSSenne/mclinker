package;

import haxe.io.BytesOutput;
import haxe.Json;
import haxe.io.Bytes;
import hx_webserver.HTTPUtils;
import hx_webserver.HTTPRequest;
import sys.net.Host;
import hx_webserver.HTTPServer;

class WebApp {
	var Server:HTTPServer;

	public function prepareHttpResponse(code:Int, mime:String, value:Bytes):Bytes {
		var bytesOutput:BytesOutput = new BytesOutput();
		bytesOutput.writeString("HTTP/1.1 " + code + " " + HTTPUtils.codeToMessage(code));
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("Content-Length: " + value.length);
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("Content-Type: " + mime);
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("Access-Control-Allow-Origin: *"); // js fetch is stupid
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString(value.toString());
		bytesOutput.writeString("\r\n");
		// trace(bytes.toString());

		return bytesOutput.getBytes();
	}

	public function new(files:Map<String, String>, graphData:String) {
		Server = new HTTPServer("0.0.0.0", 8080, false /*, false*/);
		Server.onClientConnect = (d:HTTPRequest) -> {
			trace(d.methods.join(" - "));
			var path = d.methods[1] == "/" ? "/index.html" : d.methods[1];
			if (files.exists(path)) {
				var data = files.get(path);
				if (StringTools.endsWith(path, ".js")) {
					var idx = data.indexOf("{references:{},referenceMap:{}}");
					if (idx != -1)
						data = data.substr(0, idx) + graphData + data.substr(idx + 31);
				}
				d.replyRaw(this.prepareHttpResponse(200, HTTPUtils.getMimeType(path), Bytes.ofString(data)));
			}
			d.reply("404", 404);
		}
	}
}
