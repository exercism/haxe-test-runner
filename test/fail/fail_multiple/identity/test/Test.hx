package;

using buddy.Should;

class Test extends buddy.SingleSuite {
	public function new() {
		describe("Identity function", {
			it("identity function of 1", {
				Identity.funA(1).should.be(1);
			});
			it("identity function of 1", {
				Identity.funA(2).should.be(2);
			});
			it("identity function of 1", {
				Identity.funB(1).should.be(1);
			});
			it("identity function of 1", {
				Identity.funB(2).should.be(2);
			});
		});
	}
}
