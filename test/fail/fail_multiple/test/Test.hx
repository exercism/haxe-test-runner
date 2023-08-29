package;

using buddy.Should;

class Test extends buddy.SingleSuite {
	public function new() {
		describe("Identity function", {
			it("identity function of 1", {
				FailMultiple.funA(1).should.be(1);
			});
			xit("identity function of 1", {
				FailMultiple.funA(2).should.be(2);
			});
			xit("identity function of 1", {
				FailMultiple.funB(1).should.be(1);
			});
			it("identity function of 1", {
				FailMultiple.funB(2).should.be(2);
			});
		});
	}
}
