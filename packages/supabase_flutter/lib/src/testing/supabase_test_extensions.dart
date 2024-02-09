extension RangeTypeExtension on String {
  String removeBrackets() => substring(1, length - 1);
}

extension StringUtils on String {
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

  String last() => isEmpty ? '' : this[length - 1];
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

extension MapUtils on Map {
  bool contains(Map other) => other.entries.every(
        (element) => containsKey(element.key) && containsValue(element.value),
      );
}
