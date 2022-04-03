package;

class SuccessHasStdout {
	public static function identity<T>(x:T):T {
		trace("hello");
		return x;
	}
}
