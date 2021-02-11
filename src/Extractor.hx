package;

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
		// regex for buddy's 'it' function
		var reg = new EReg('it\\("$specDescription", \\{(.+?;?)\\}\\);', "gms");
		if (reg.match(code)) {
			var match = reg.matched(1);
			var trimmed = ~/[\n\r]+/gms.split(match).map(StringTools.trim);
			var formatted = trimmed.join("\n").trim();
			return formatted;
		}
		throw 'Spec description not found: $specDescription';
	}
}
