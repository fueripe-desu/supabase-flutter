class FilterBuilder {
  final List<Map<String, dynamic>> _data;
  const FilterBuilder(List<Map<String, dynamic>> data) : _data = data;

  List<Map<String, dynamic>> execute() => _data;

  FilterBuilder eq(String column, dynamic value) => _filter(
        test: (element) => element[column] == value,
      );

  FilterBuilder neq(String column, dynamic value) => _filter(
        test: (element) => element[column] != value,
      );

  FilterBuilder gt(String column, dynamic value) => _filter(
        test: (element) => element[column] > value,
      );

  FilterBuilder gte(String column, dynamic value) => _filter(
        test: (element) => element[column] >= value,
      );

  FilterBuilder lt(String column, dynamic value) => _filter(
        test: (element) => element[column] < value,
      );

  FilterBuilder lte(String column, dynamic value) => _filter(
        test: (element) => element[column] <= value,
      );

  FilterBuilder like(String column, String pattern) => _filter(
        test: (element) => _like(
          element[column],
          pattern,
          caseSensitive: true,
        ),
      );

  FilterBuilder ilike(String column, String pattern) => _filter(
        test: (element) => _like(
          element[column],
          pattern,
          caseSensitive: false,
        ),
      );

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

  FilterBuilder _filter({
    required bool Function(
      Map<String, dynamic> element,
    ) test,
  }) {
    final data = _data;
    final newData = data.where(test).toList();

    return FilterBuilder(newData);
  }
}
