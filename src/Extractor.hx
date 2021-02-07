package;

using StringTools;

/**
 * Helper functions for extracting test_code
 */
class Extractor {
	// currently using regex, the idea is to replace this with something more robust later
	public static function getTestCodeFromSpec(code:String, specDescription:String):String {
		// regex for buddy's 'it' function
		var reg = new EReg('it\\("$specDescription", \\{(.+?)\\}\\);', "gms");
		if (reg.match(code)) {
			var match = reg.matched(1);
			var unspaced = ~/\s*/g.replace(match, "");
			var formatted = unspaced.split(";").join(";\n");
			return formatted.trim();
		}
		return null;
	}
}
