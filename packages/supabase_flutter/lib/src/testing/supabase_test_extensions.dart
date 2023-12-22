extension RangeTypeExtension on String {
  String removeBrackets() => substring(1, length - 1);
}

extension StringUtils on String {
  String removeSpaces() => replaceAll(' ', '');
}

extension ListStringUtils on List<String> {
  List<String> trimAll() => map((e) => e.trim()).toList();
}
