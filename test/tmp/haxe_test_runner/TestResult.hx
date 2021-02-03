package;

import RunnerResult;

class TestResult {
	public var name:String;
	public var status:ResultStatus;
	public var message:String;
	public var output:String;
	public var testCode:String;

	public function new() {}

	public function toJsonObj():Dynamic {
		return {
			name: name,
			status: status.getName().toLowerCase(),
			message: message,
			output: output,
			testCode: testCode
		};
	}
}
