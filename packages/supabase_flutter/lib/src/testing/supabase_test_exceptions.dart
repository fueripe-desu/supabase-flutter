class RangeTypeException implements Exception {
  String message;

  RangeTypeException(this.message);

  @override
  String toString() {
    return 'Invalid range: $message';
  }
}

class TextSearchException implements Exception {
  String message;

  TextSearchException(this.message);

  @override
  String toString() {
    return message;
  }
}
