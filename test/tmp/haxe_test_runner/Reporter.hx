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
	public function new() {}

	public function start():Promise<Bool> {
		return resolveImmediately(true);
	}

	public function progress(spec:Spec):Promise<Spec> {
		return resolveImmediately(spec);
	}

	public function done(suites:Iterable<Suite>, status:Bool):Promise<Iterable<Suite>> {
		var testResults = suites.map(s -> suiteToTestResults(s)).flatten();
		var resultStatus = status ? ResultStatus.Pass : ResultStatus.Fail();
		var runnerResult = new RunnerResult();
		runnerResult.status = resultStatus;
		runnerResult.tests = testResults;

		var args = Sys.args();
		var flagIdx = args.indexOf("-resultPath");
		var resultPath = args[flagIdx + 1];
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
		var r = new TestResult();
		r.name = spec.description;
		r.testCode = spec.fileName;
		switch (spec.status) {
			case Unknown:
				r.status = ResultStatus.Error("");
				r.message = spec.traces.join("\n");
			case Passed:
				r.status = ResultStatus.Pass;
			case Pending:
				r.status = ResultStatus.Pass;
			case Failed:
				r.status = ResultStatus.Fail(spec.description);
				var failureErrors = spec.failures.map(f -> f.error).join("\n");
				// var failureStacks = spec.failures.map(f -> f.stack).join("\n");
				r.message = failureErrors;
				// r.output = "";
		}
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
