package;

class Identity {
	static var e = throw "compile exception";

	public static function identity<T>(x:T):T {
		return x;
	}
}
