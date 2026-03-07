class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isLeft;

  const Either._leftVal(L value)
      : _left = value,
        _right = null,
        _isLeft = true;

  const Either._rightVal(R value)
      : _left = null,
        _right = value,
        _isLeft = false;

  static Either<L, R> leftOf<L, R>(L value) => Either._leftVal(value);
  static Either<L, R> rightOf<L, R>(R value) => Either._rightVal(value);

  bool get isLeft => _isLeft;
  bool get isRight => !_isLeft;

  L get leftValue => _left as L;
  R get rightValue => _right as R;

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    if (_isLeft) return onLeft(_left as L);
    return onRight(_right as R);
  }
}
