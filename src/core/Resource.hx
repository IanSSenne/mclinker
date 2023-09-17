package core;

class Resource {
	var type:ResourceType;
	var id:String;

	public function new(type:ResourceType, id:String) {
		this.type = type;
		this.id = id;
	}

	public function getReferenceString():Array<String> {
		return ['$id'];
	}

	public function getCommands():Array<String> {
		throw "Not implemented";
	}

	public function getId():String {
		var resourceIdentifier:String = switch (this.type) {
			case AnimationController:
				"animation-controller";
			case Animation:
				"animation";
			case Function:
				"function";
			case FunctionTag:
				"function-tag";
			case Script:
				"script";
			case Dialogue:
				"dialogue";
		};
		return '$resourceIdentifier:$id';
	}
}
