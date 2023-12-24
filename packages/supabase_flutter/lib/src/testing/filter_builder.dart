import 'package:supabase_flutter/src/testing/range_type.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';

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

  FilterBuilder isFilter(String column, Object? value) => _filter(
        test: (element) => element[column] == value,
      );

  FilterBuilder inFilter(String column, List<dynamic> value) => _filter(
        test: (element) => value.contains(
          element[column],
        ),
      );

  FilterBuilder contains(String column, Object value) =>
      _contains(column, value, false);

  FilterBuilder containedBy(String column, Object value) =>
      _contains(column, value, true);

  FilterBuilder rangeGt(String column, String range) {
    final rangeValue = RangeType.createRange(range: range);

    return _filter(test: (element) {
      final elementRange = RangeType.createRange(range: element[column]);
      return elementRange > rangeValue;
    });
  }

  FilterBuilder rangeGte(String column, String range) {
    final rangeValue = RangeType.createRange(range: range);

    return _filter(test: (element) {
      final elementRange = RangeType.createRange(range: element[column]);
      return elementRange >= rangeValue;
    });
  }

  FilterBuilder _contains(String column, Object value, bool isContainedBy) {
    if (value is String) {
      final rangeValue = RangeType.createRange(range: value);
      return _filter(
        test: (element) {
          final data = element[column];
          final rangeToTest = RangeType.createRange(range: data);

          late final RangeComparable comparable;
          late final RangeType rangeToCompare;

          if (isContainedBy) {
            comparable = rangeToTest.getComparable();
            rangeToCompare = rangeValue;
          } else {
            comparable = rangeValue.getComparable();
            rangeToCompare = rangeToTest;
          }

          return rangeToCompare.isInRange(comparable.lowerRange) &&
              rangeToCompare.isInRange(comparable.upperRange);
        },
      );
    }
    if (value is List) {
      return _filter(
        test: (row) {
          final data = row[column];

          if (data is List) {
            if (isContainedBy) {
              return data.every((element) => value.contains(element));
            }

            return value.every((element) => data.contains(element));
          }

          if (isContainedBy) {
            return value.any((element) => element == data);
          }

          return value.every((element) => element == data);
        },
      );
    }

    if (value is Map) {
      return _filter(
        test: (row) {
          final data = row[column];

          if (data is Map) {
            if (isContainedBy) {
              return value.contains(data);
            }
            return data.contains(value);
          }

          throw Exception(
            'Invalid use of \'${isContainedBy ? 'containedBy' : 'contains'}\' filter. Please when using contains with jsonb make sure that the target data is also a json map.',
          );
        },
      );
    }

    throw Exception(
      'Invalid use of \'${isContainedBy ? 'containedBy' : 'contains'}\' filter. Must be used with range, list or jsonb.',
    );
  }

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
    final List<Map<String, dynamic>> newData = [];
    for (final row in _data) {
      // Extract the value of the specified column for the current row
      final data = row[column];
      for (final pattern in patterns) {
        // If it does not match any of the patterns, it breaks out of the loop
        if (!_like(data, pattern, caseSensitive: caseSensitive)) {
          break;
        }

        // If the current pattern is the last one, it means all others have passed
        if (pattern == patterns.last) {
          newData.add(row);
        }
      }
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
