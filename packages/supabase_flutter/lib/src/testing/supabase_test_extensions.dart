extension RangeTypeExtension on String {
  String removeBrackets() => substring(1, length - 1);
}

extension StringUtils on String {
  String get first => isEmpty ? '' : this[0];
  String get last => isEmpty ? '' : this[length - 1];

  int? get firstIndex => isEmpty ? null : 0;
  int? get lastIndex => isEmpty ? null : length - 1;

  String removeSpaces() => replaceAll(' ', '');
  String removeExtraSpaces() => replaceAll(RegExp(r'\s+'), ' ');

  bool endsWithEither(List<String> endings) {
    for (final ending in endings) {
      if (endsWith(ending)) {
        return true;
      }
    }

    return false;
  }

  int count(String element) {
    return split('').where((item) => item == element).length;
  }

  bool equalsEither(List<String> options) {
    for (String option in options) {
      if (this == option) {
        return true;
      }
    }
    return false;
  }

  bool containsEither(List<String> options) {
    for (String option in options) {
      if (contains(option)) {
        return true;
      }
    }
    return false;
  }
}

extension ListStringUtils on List<String> {
  List<String> trimAll() => map((e) => e.trim()).toList();
  List<String> sublistAndRemove(int start, int end) {
    final extractedList = sublist(start, end);
    removeRange(start, end);
    return extractedList;
  }

  int count(String element) {
    return where((item) => item == element).length;
  }
}
