package;

import RunnerResult;

/**
 * Result object returned from a single test run
 */
class TestResult {
	public var name:String;
	public var status:ResultStatus;
	public var message:String;
	public var output:String;
	public var testCode:String;

	public function new() {}

	public function toJsonObj():Dynamic {
		var cleanedOutput:String = null;
		if (output != null)
			// drop leading path
			cleanedOutput = output.split("\n").map(t -> t.substr(t.indexOf(" ") + 1)).join("\n");
		var cleanedMessage:String = null;
		if (message != null)
			// strip folder path
			cleanedMessage = message.split("\n").map(s -> s.split("/").pop()).join("\n");
		var x = {
			name: name,
			status: status.getName().toLowerCase(),
			message: cleanedMessage,
			output: truncateOutput(cleanedOutput),
			testCode: testCode
		};
		return x;
	}

	static function truncateOutput(output:String, maxLen = 500):String {
		if (output == null)
			return null;
		var msg = '...\n[Output was truncated. Please limit to $maxLen chars]';
		if (output.length <= maxLen)
			return output;
		var truncated = output.substr(0, maxLen);
		return truncated + msg;
	}
}
