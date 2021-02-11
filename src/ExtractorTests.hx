import Extractor.getTestCodeFromSpec;

using buddy.Should;

class ExtractorTests extends buddy.SingleSuite {
	public function new() {
		var testSample = '
package;

using buddy.Should;

class SUT extends buddy.SingleSuit {
    describe("suite under test", {
        ::specs::
    });
}';

		var tmpl = new haxe.Template(testSample);

		describe("getTestCodeFromSpec function", {
			it("throws exceptin when spec is not found", {
				var code = tmpl.execute({specs: null});
				getTestCodeFromSpec.bind(code, "non-existing spec").should.throwType(String);
			});

			it("returns body of single statement spec", {
				var spec = '
it("spec", {
    1.should.be(1);
});';
				var code = tmpl.execute({specs: spec});
				getTestCodeFromSpec(code, "spec").should.be("1.should.be(1);");
			});

			it("returns body of multiple statement spec", {
				var spec = '
it("spec", {
    1.should.be(1);
    2.should.be(2);
});';
				var code = tmpl.execute({specs: spec});
				var expected = '1.should.be(1);\n2.should.be(2);';
				getTestCodeFromSpec(code, "spec").should.be(expected);
			});

			it("ignores body of other specs", {
				var specs = '
it("other spec 1", {
    0.should.be(0);
});
it("spec", {
    1.should.be(1);
    2.should.be(2);
});
it("other spec 2", {
    3.should.be(3);
});';
				var code = tmpl.execute({specs: specs});
				var expected = '1.should.be(1);\n2.should.be(2);';
				getTestCodeFromSpec(code, "spec").should.be(expected);
			});

			it("trims line breaks inside body", {
				var specs = '
it("spec", {
    1.should.be(1);

    2.should.be(2);
});';

				var code = tmpl.execute({specs: specs});
				var expected = '1.should.be(1);\n2.should.be(2);';
				getTestCodeFromSpec(code, "spec").should.be(expected);
			});

			it("trims line breaks surrounding body", {
				var specs = '
it("spec", {

    1.should.be(1);
    2.should.be(2);

});';

				var code = tmpl.execute({specs: specs});
				var expected = '1.should.be(1);\n2.should.be(2);';
				getTestCodeFromSpec(code, "spec").should.be(expected);
			});

			it("preserves comments", {
				var specs = '
it("spec", {
    // comment 1
    1.should.be(1);
    // comment 2
    2.should.be(2);
    // comment 3
});';

				var code = tmpl.execute({specs: specs});
				var expected = [
					"// comment 1",
					"1.should.be(1);",
					"// comment 2",
					"2.should.be(2);",
					"// comment 3"
				];
				getTestCodeFromSpec(code, "spec").should.be(expected.join("\n"));
			});

			it("handles mixed spacing", {
				var specs = '
it("spec", {
        
    //comment 1
    1.should.be(1);
    //  comment 2
    2.should.be( 2 );
    // comment  3

});';

				var code = tmpl.execute({specs: specs});
				var expected = [
					"//comment 1",
					"1.should.be(1);",
					"//  comment 2",
					"2.should.be( 2 );",
					"// comment  3"
				];
				getTestCodeFromSpec(code, "spec").should.be(expected.join("\n"));
			});

			it("can extract multiline expressions", {
				var specs = '
it("spec", {
	var xs = [
		for (y in ys)
			if (fun(y))
				y
	];
    1.should.be(1);
});';

				var code = tmpl.execute({specs: specs});
				var expected = ["var xs = [", "for (y in ys)", "if (fun(y))", "y", "];", "1.should.be(1);"];
				getTestCodeFromSpec(code, "spec").should.be(expected.join("\n"));
			});

			it("escapes special chars in specDescription", {
				var specs = '
it("({[.+,-;]})", {
    1.should.be(1);
});';

				var code = tmpl.execute({specs: specs});
				var expected = "1.should.be(1);";
				getTestCodeFromSpec(code, "({[.+,-;]})").should.be(expected);
			});
		});
	}
}
