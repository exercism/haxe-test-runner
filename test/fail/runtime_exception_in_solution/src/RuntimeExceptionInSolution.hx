package;

class RuntimeExceptionInSolution {
	public static function identity<T>(x:T):T {
		throw "runtime exception";
	}
}
