package;

using buddy.Should;

class Test extends buddy.SingleSuite {
	public function new() {
		describe("Identity function", {
			it("identity function of 1", {
				CompileErrorMissingSemicolon.identity(1).should.be(1);
			});
		});
	}
}
