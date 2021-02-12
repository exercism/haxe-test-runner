package;

import sys.io.File;

using StringTools;

/**
 * Helper functions for extracting test_code
 * TODO: replace with something more robust
 */
class Extractor {
	/**
	 * Extracts the body of a spec from povided code, using its specDescription
	 * This assumes that specDescriptions are unique, which is not enforced by Buddy
	 * @param code
	 * @param specDescription
	 * @return String
	 */
	public static function getTestCodeFromSpec(code:String, specDescription:String):String {
		// Escape special characters found in specDescription so they're
		// interpreted literally inside a regex pattern
		function escape(str:String)
			return [
				for (i in 0...str.length)
					switch str.charAt(i) {
						case pair = "(" | ")" | "[" | "]" | "{" | "}":
							'\\$pair';
						case other:
							EReg.escape(other);
					}
			].join("");
		// pattern for buddy's 'it' function
		var pat = 'it\\("${escape(specDescription)}", \\{(.+?;?)\\}\\);';
		var reg = new EReg(pat, "gms");
		if (reg.match(code)) {
			var match = reg.matched(1);
			var trimmed = ~/[\n\r]+/gms.split(match).map(StringTools.trim);
			var formatted = trimmed.join("\n").trim();
			return formatted;
		}
		throw 'Spec description not found: $specDescription';
	}
}
