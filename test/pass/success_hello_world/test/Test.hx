package;

using buddy.Should;

class Test extends buddy.SingleSuite {
	public function new() {
		describe("Hello World", {
			it("Say Hi!", {
				SuccessHelloWorld.hello().should.be("Hello, World!");
			});
		});
	}
}
