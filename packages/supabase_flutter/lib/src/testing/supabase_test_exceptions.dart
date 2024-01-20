class RangeTypeException implements Exception {
  String message;

  RangeTypeException(this.message);

  @override
  String toString() {
    return 'Invalid range: $message';
  }
}
