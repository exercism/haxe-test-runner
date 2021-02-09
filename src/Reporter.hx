package;

import haxe.Json;
import sys.io.File;
import RunnerResult;
import promhx.Deferred;
import buddy.BuddySuite;
import promhx.Promise;

using Lambda;
using StringTools;

/**
 * A custom reporter to output test results as json conforming to the exercism v3 spec
 */
class Reporter implements buddy.reporting.Reporter {
	// the path to output results.json to, currently passed in from the calling process
	var resultPath:String;

	public function new() {
		var args = Sys.args();
		var flagIdx = args.indexOf("-resultPath");
		resultPath = args[flagIdx + 1];
	}

	/**
	 * Called just before tests are run. If promise is resolved with "false",
	 * testing will immediately exit with status 1.
	 */
	public function start():Promise<Bool> {
		return resolveImmediately(true);
	}

	/**
	 * Called for every Spec. Can be used to display realtime notifications.
	 * Resolve with the same spec as the parameter.
	 */
	public function progress(spec:Spec):Promise<Spec> {
		return resolveImmediately(spec);
	}

	/**
	 * Called after the last spec is run. Useful for displaying a test summary.
	 * Resolve with the same iterable as the parameter.
	 * Status is true if all tests passed, otherwise false.
	 */
	public function done(suites:Iterable<Suite>, status:Bool):Promise<Iterable<Suite>> {
		var runnerResult = new RunnerResult();
		runnerResult.status = status ? ResultStatus.Pass : ResultStatus.Fail();
		runnerResult.tests = suites.map(s -> suiteToTestResults(s)).flatten();

		var resultJson = Json.stringify(runnerResult.toJsonObj(), "\t");
		File.saveContent(resultPath, resultJson);
		return resolveImmediately(suites);
	}

	static function suiteToTestResults(suite:Suite):Array<TestResult> {
		var results = new Array<TestResult>();
		for (step in suite.steps) {
			switch step {
				case TSpec(spec):
					results.push(specToTestResult(spec));
				case TSuite(s):
					results = results.concat(suiteToTestResults(s));
			}
		}
		return results;
	}

	static function specToTestResult(spec:Spec):TestResult {
		var status:ResultStatus;
		switch (spec.status) {
			case Unknown:
				status = ResultStatus.Fail();
			case Passed:
				status = ResultStatus.Pass;
			case Pending:
				status = ResultStatus.Fail();
			case Failed:
				status = ResultStatus.Fail();
		}
		var r = new TestResult();
		r.status = status;
		r.name = spec.description;

		var code = File.getContent(spec.fileName);
		r.testCode = Extractor.getTestCodeFromSpec(code, spec.description);

		var output = spec.traces.join("\n");
		r.output = (output.length == 0) ? null : output;

		var errorMsg = spec.failures.map(f -> f.error).join("\n");
		r.message = (errorMsg.length == 0) ? null : errorMsg;
		return r;
	}

	// Convenience method
	private function resolveImmediately<T>(obj:T):Promise<T> {
		var deferred = new Deferred<T>();
		var promise = deferred.promise();
		deferred.resolve(obj);
		return promise;
	}
}
