package;

import haxe.Json;

enum ResultStatus {
	Pass;
	Fail(?message:String);
	Error(message:String);
}

/**
 * Result object returned for runner invocation
 */
class RunnerResult {
	final version = 2;

	public var status:ResultStatus;
	public var message:String;
	public var tests:Array<TestResult> = [];

	public function new() {}

	public function toJsonObj():Dynamic {
		var message:String = null;
		switch (status) {
			// Extract ResultStatus msg to message field when found
			case Fail(msg), Error(msg):
				// strip folder path
				if (msg != null)
					message = msg.split("\n").map(s -> s.split("/").pop()).join("\n");
			case Pass:
		}
		return {
			version: version,
			status: status.getName().toLowerCase(),
			tests: tests.map(t -> t.toJsonObj()),
			message: message
		};
	}
}
