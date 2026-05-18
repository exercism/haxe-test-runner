package;

using buddy.Should;

class Test extends buddy.SingleSuite {
	public function new() {
		describe("Identity function", {
			it("identity function of 0", {
				FailPartial.identity(0).should.be(1);
			});
			it("identity function of 1", {
				FailPartial.identity(1).should.be(1);
			});
		});
	}
}
