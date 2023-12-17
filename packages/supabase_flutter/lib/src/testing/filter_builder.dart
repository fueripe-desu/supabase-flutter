class FilterBuilder {
  final List<Map<String, dynamic>> _data;
  const FilterBuilder(List<Map<String, dynamic>> data) : _data = data;

  List<Map<String, dynamic>> execute() => _data;

  FilterBuilder eq(String column, Object value) {
    if (value is List) {
      final newData = _data
          .where(
            (element) => value.contains(element[column]),
          )
          .toList();
      return FilterBuilder(newData);
    }

    final newData = _data.where((element) => element[column] == value).toList();
    return FilterBuilder(newData);
  }

  FilterBuilder neq(String column, Object value) {
    if (value is List) {
      final newData = _data
          .where(
            (element) => !value.contains(element[column]),
          )
          .toList();
      return FilterBuilder(newData);
    }

    final newData = _data.where((element) => element[column] != value).toList();
    return FilterBuilder(newData);
  }

  FilterBuilder gt(String column, Object value) => _filter(
        test: (element) => element[column] > value,
      );

  FilterBuilder gte(String column, Object value) => _filter(
        test: (element) => element[column] >= value,
      );

  FilterBuilder lt(String column, Object value) => _filter(
        test: (element) => element[column] < value,
      );

  FilterBuilder lte(String column, Object value) => _filter(
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

  FilterBuilder likeAllOf(String column, List<String> patterns) =>
      _likeAllOf(column, patterns, true);

  FilterBuilder ilikeAllOf(String column, List<String> patterns) =>
      _likeAllOf(column, patterns, false);

  FilterBuilder likeAnyOf(String column, List<String> patterns) =>
      _likeAnyOf(column, patterns, true);

  FilterBuilder ilikeAnyOf(String column, List<String> patterns) =>
      _likeAnyOf(column, patterns, false);

  FilterBuilder _likeAnyOf(
      String column, List<String> patterns, bool caseSensitive) {
    // Initialize an empty list to store filtered data
    final List<Map<String, dynamic>> newData = [];
    for (final row in _data) {
      // Extract the value of the specified column for the current row
      final data = row[column];
      for (final pattern in patterns) {
        // If a match is found, add the matched data to the newData list
        // and break out of the loop, therefore only adding if it satisfies one
        // of the patterns
        if (_like(data, pattern, caseSensitive: caseSensitive)) {
          newData.add(row);
          break;
        }
      }
    }

    return FilterBuilder([...newData]);
  }

  FilterBuilder _likeAllOf(
      String column, List<String> patterns, bool caseSensitive) {
    // Temporary list to hold filtered data
    final List<Map<String, dynamic>> newData = [];

    for (final pattern in patterns) {
      final List<Map<String, dynamic>> dataToFilter = [];

      if (newData.isNotEmpty) {
        // If the newData list is empty, add data from the _data list
        dataToFilter.addAll(newData);
      } else {
        dataToFilter.addAll(_data);
      }

      // Filter the dataToFilter list to retain elements where the specified column matches the pattern
      dataToFilter.retainWhere((element) =>
          _like(element[column], pattern, caseSensitive: caseSensitive));

      newData.clear();
      newData.addAll(dataToFilter);
    }

    return FilterBuilder([...newData]);
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
