package;

class CompileErrorUndeclaredVariable {
	public static function identity<T>(x:T):T {
		y = 1;
		return x;
	}
}
