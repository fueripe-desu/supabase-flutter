class FilterBuilder {
  final List<Map<String, dynamic>> _data;
  const FilterBuilder(List<Map<String, dynamic>> data) : _data = data;

  List<Map<String, dynamic>> execute() => _data;

  FilterBuilder eq(String column, dynamic value) {
    final data = _data;
    final newData = data.where((element) => element[column] == value).toList();

    return FilterBuilder(newData);
  }

  FilterBuilder neq(String column, dynamic value) {
    final data = _data;
    final newData = data.where((element) => element[column] != value).toList();

    return FilterBuilder(newData);
  }

  FilterBuilder gt(String column, dynamic value) {
    final data = _data;
    final newData = data.where((element) => element[column] > value).toList();

    return FilterBuilder(newData);
  }

  FilterBuilder gte(String column, dynamic value) {
    final data = _data;
    final newData = data.where((element) => element[column] >= value).toList();

    return FilterBuilder(newData);
  }

  FilterBuilder lt(String column, dynamic value) {
    final data = _data;
    final newData = data.where((element) => element[column] < value).toList();

    return FilterBuilder(newData);
  }

  FilterBuilder lte(String column, dynamic value) {
    final data = _data;
    final newData = data.where((element) => element[column] <= value).toList();

    return FilterBuilder(newData);
  }

  FilterBuilder like(String column, String pattern) {
    final data = _data;
    final newData = data
        .where(
            (element) => _like(element[column], pattern, caseSensitive: true))
        .toList();

    return FilterBuilder(newData);
  }

  FilterBuilder ilike(String column, String pattern) {
    final data = _data;
    final newData = data
        .where(
            (element) => _like(element[column], pattern, caseSensitive: false))
        .toList();

    return FilterBuilder(newData);
  }

  bool _like(String value, String pattern, {bool caseSensitive = true}) {
    // Escape regex metacharacters in the pattern
    final escapedPattern = pattern.replaceAllMapped(
        RegExp(r'[.*+?^${}()|[\]\\]'), (match) => '\\${match.group(0)}');

    // Replace SQL wildcards with regex equivalents
    final regexPattern =
        '^${escapedPattern.replaceAll('%', '.*').replaceAll('_', '.')}\$';

    // Create RegExp with case sensitivity option
    final regex =
        RegExp(regexPattern, caseSensitive: caseSensitive ? true : false);

    // Match input against the regex pattern
    return regex.hasMatch(value);
  }
}
