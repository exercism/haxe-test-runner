package;

import haxe.Json;
import haxe.ds.StringMap;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem as FS;

using buddy.Should;
using StringTools;
using Lambda;

class RunnerTests extends buddy.SingleSuite {
	private function listDirectoriesInPath(path) {
		return FS.readDirectory(path)
			.map(item -> Path.join([path, item]))
			.filter(FS.isDirectory);
	}
	
	public function new() {
		var args = Sys.args();
		var flagIdx = args.indexOf("-testsPath");
		var testsDir = args[flagIdx + 1];
		var runnerBin = Path.join([testsDir, "..", "bin", "runner.n"]);
		var outputDirs = []; // keep track of outputDirs to remove after suite completion

		// traverse each directory, running contained tests and comparing result to expected_results.json
		for (status in ["error", "pass", "fail"]) {
			var testsPath = Path.join([testsDir, status]);
			var testDirs = listDirectoriesInPath(testsPath);
			
			for (testDir in testDirs) {
				// Get trailing portion of the path as the test slug
				var slug = Path.removeTrailingSlashes(testDir).split('/').pop();
				var inputDir = Path.join([testDir, "src"]);
				var outputDir = testDir;

				var runnerProc = new sys.io.Process("neko", [
					runnerBin,
					slug,
					inputDir,
					outputDir
				]);
				
				var exitCode = runnerProc.exitCode();
				var error = runnerProc.stderr.readAll().toString();
				
				if (error.length != 0)
					trace(error);
				
				runnerProc.close();

				var testName = testDir.split("/").pop();
				var resultFile = Path.join([outputDir, "results.json"]);
				var resultWasOutput = FS.exists(resultFile);
				var expectedExitCode = (error.length == 0 && resultWasOutput) ? 0 : 1;
				
				describe(testName, {
					it('exit code should be $expectedExitCode', {
						exitCode.should.be(expectedExitCode);
					});

					it("results.json should match expected", {
						var expectedFile = Path.join([testDir, "expected_results.json"]);
						var actualFile = Path.join([outputDir, "results.json"]);

						var expectedResults = Json.parse(File.getContent(expectedFile));
						var actualResults = Json.parse(File.getContent(actualFile));

						function compareJsonObjects(expected:Dynamic, actual:Dynamic, keysSeen:Array<String>):Void {
							for (key in Reflect.fields(expected)) {
								keysSeen.push(key);
								var expectedValue = Reflect.field(expected, key);
								var actualValue = Reflect.field(actual, key);
						
								if (Std.isOfType(expectedValue, StringMap)) {
									compareJsonObjects(expectedValue, actualValue, keysSeen);
								} else if (Std.isOfType(expectedValue, Array)) {
									var expectedArray: Array<Dynamic> = cast expectedValue;
						      var actualArray: Array<Dynamic> = cast actualValue;

									// This works but the error messages are difficult to read
									// actualArray.should.containAll(expectedArray);
					
						      for(i in 0...expectedArray.length) {
										keysSeen.push('[$i]');
						        compareJsonObjects(expectedArray[i], actualArray[i], keysSeen);
										keysSeen.pop();
						      }
								} else {
									expectedValue = Std.string(expectedValue);
									actualValue = Std.string(actualValue);

									// Buddy doesn't print the key of the mismatched values, so we'll do it
									if(actualValue != expectedValue) {
										var badKey = keysSeen.join(".");
										trace(badKey);
									}
									
									actualValue.should.be(expectedValue);
								}

								keysSeen.pop();
							}
						}

						compareJsonObjects(expectedResults, actualResults, []);
					});
				});
					
				outputDirs.push(outputDir);
			}
		}
		// clean up outputDirs
		afterAll({
			for (dir in outputDirs) {
				var resultFile = Path.join([dir, "results.json"]);
				if(FS.exists(resultFile)) {
					FS.deleteFile(resultFile);
				} else {
					trace('File already deleted: $resultFile');
				}
			}
		});
	}
}
