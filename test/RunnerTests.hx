package;

import haxe.io.Path;
import sys.io.File;
import haxe.Json;
import sys.FileSystem as FS;

using buddy.Should;
using StringTools;
using Lambda;

class RunnerTests extends buddy.SingleSuite {
	public function new() {
		var args = Sys.args();
		var flagIdx = args.indexOf("-testsPath");
		var testsDir = args[flagIdx + 1];
		var runnerBin = Path.join([testsDir, "..", "bin", "runner.n"]);

		function filterDirs(path)
			return FS.readDirectory(path).map(x -> Path.join([path, x])).filter(FS.isDirectory);

		for (status in ["error", "pass", "fail"]) {
			var testsPath = Path.join([testsDir, status]);
			var testDirs = filterDirs(testsPath);
			for (testDir in testDirs) {
				var slug = filterDirs(testDir)[0].split("/").pop();
				var inputDir = Path.join([testDir, slug]);
				var outputDir = Path.join([testDir, "output"]);
				var runnerProc = new sys.io.Process("neko", [
					runnerBin,
					slug,
					Path.addTrailingSlash(inputDir),
					Path.addTrailingSlash(outputDir)
				]);
				var exitCode = runnerProc.exitCode();
				var error = runnerProc.stderr.readAll().toString();
				if (error.length != 0)
					trace(error);
				runnerProc.close();

				var testName = testDir.split("/").pop();
				var resultFile = Path.join([outputDir, "results.json"]);
				var resultWasOutput = FS.exists(resultFile);
				var expectedExitCode = resultWasOutput ? 0 : 1;
				describe(testName, {
					it('exit code should be $expectedExitCode', {
						exitCode.should.be(expectedExitCode);
					});

					it("results.json should match expected", {
						var expectedFile = Path.join([testDir, "expected_results.json"]);
						var expectedResults = Json.parse(File.getContent(expectedFile));
						var actualFile = Path.join([outputDir, "results.json"]);
						var actualResults = Json.parse(File.getContent(actualFile));
						// convert back to json string for comparison
						Json.stringify(actualResults).should.be(Json.stringify(expectedResults));
					});
				});
				// cleanup
				// FileTools.deleteDirRecursively(outputDir);
			}
		}
	}
}
