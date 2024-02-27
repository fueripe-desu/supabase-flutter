import 'package:collection/collection.dart';
import 'package:supabase_flutter/src/testing/postgrest/supabase_test_postgrest.dart';
import 'package:supabase_flutter/src/testing/range_type/range_comparable.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum FilterDataType {
  string,
  integer,
  boolean,
  float,
  datetime,
}

class FilterBuilder {
  final List<Map<String, dynamic>> _data;
  final List<FilterError> _errorStack;

  FilterBuilder(List<Map<String, dynamic>> data, {List<FilterError>? errors})
      : _data = List.from(data),
        _errorStack = List.from(errors ?? []);

  FilterResult execute() => FilterResult(
        isValid: _errorStack.isEmpty,
        error: _errorStack.isNotEmpty ? _errorStack.last : null,
        rows: _data,
      );

  FilterBuilder eq(String column, Object value) {
    if (value is List) {
      final newData = _data
          .where(
            (element) => value.contains(element[column]),
          )
          .toList();
      return FilterBuilder(newData);
    }

    return _eq(column, value);
  }

  FilterBuilder _eq(String column, Object value) {
    // _checkType(column, value);

    return FilterBuilder(
      _data.where((element) {
        final (columnCast, valueCast) = _castImplicitly(element[column], value);
        return columnCast == valueCast;
      }).toList(),
      errors: _errorStack,
    );
  }

  (dynamic, dynamic) _castImplicitly(dynamic columnValue, dynamic value) {
    if (columnValue is String) {
      if (DateTime.tryParse(columnValue) != null) {
        final columnParse = DateTime.parse(columnValue);
        final valueParse = DateTime.tryParse(value);

        if (valueParse != null) {
          return (columnParse, valueParse);
        }
      } else {
        return (columnValue, value.toString());
      }
    }

    return (null, null);
  }

  void _checkType(String column, Object value) {
    final columnValue = _data.first[column];
    if (_isComplexType(columnValue)) {
      final parsedColumnValue = _parseBaseTypes(columnValue.toString());

      if (_isComplexType(value)) {
        _setError(
          message: 'Value mistmatch between input and column value',
          code: '1234',
        );
        return;
      }

      final parsedValue = _parseBaseTypes(value.toString());

      if (parsedColumnValue.runtimeType != parsedValue.runtimeType) {
        _setError(
          message: 'Value mistmatch between input and column value',
          code: '1234',
        );
        return;
      }
    }
  }

  bool _isComplexType(Object value) =>
      value is List || value is Map || value is Set;

  bool _isNotComplexType(Object value) =>
      value is! List && value is! Map && value is! Set;

  FilterBuilder eqAll(String column, List value) {
    final newData = _data
        .where(
          (element) => value.every((element2) => element[column] == element2),
        )
        .toList();
    return FilterBuilder(newData);
  }

  FilterBuilder neq(String column, Object value) => _notEqualTo(column, value);

  FilterBuilder isDistinct(String column, Object? value) =>
      _notEqualTo(column, value);

  FilterBuilder gt(String column, Object value) => _filter(
        test: (element) => element[column] > value,
      );

  FilterBuilder gtAny(String column, List values) => _filter(
        test: (element) => values.any((value) => element[column] > value),
      );

  FilterBuilder gtAll(String column, List values) => _filter(
        test: (element) => values.every((value) => element[column] > value),
      );

  FilterBuilder gte(String column, Object value) => _filter(
        test: (element) => element[column] >= value,
      );

  FilterBuilder gteAny(String column, List values) => _filter(
        test: (element) => values.any((value) => element[column] >= value),
      );

  FilterBuilder gteAll(String column, List values) => _filter(
        test: (element) => values.every((value) => element[column] >= value),
      );

  FilterBuilder lt(String column, Object value) => _filter(
        test: (element) => element[column] < value,
      );

  FilterBuilder ltAny(String column, List values) => _filter(
        test: (element) => values.any((value) => element[column] < value),
      );

  FilterBuilder ltAll(String column, List values) => _filter(
        test: (element) => values.every((value) => element[column] < value),
      );

  FilterBuilder lte(String column, Object value) => _filter(
        test: (element) => element[column] <= value,
      );

  FilterBuilder lteAny(String column, List values) => _filter(
        test: (element) => values.any((value) => element[column] <= value),
      );

  FilterBuilder lteAll(String column, List values) => _filter(
        test: (element) => values.every((value) => element[column] <= value),
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

  FilterBuilder rangeGt(String column, String range) => _compareRanges(
        column: column,
        range: range,
        compareFunc: (inputRange, rowRange) => rowRange > inputRange,
      );

  FilterBuilder rangeGtAny(String column, List<String> rangeList) => _filter(
        test: (element) => rangeList.any(
          (range) =>
              RangeType.createRange(range: element[column]) >
              RangeType.createRange(range: range),
        ),
      );

  FilterBuilder rangeGtAll(String column, List<String> rangeList) => _filter(
        test: (element) => rangeList.every(
          (range) =>
              RangeType.createRange(range: element[column]) >
              RangeType.createRange(range: range),
        ),
      );

  FilterBuilder rangeGte(String column, String range) => _compareRanges(
        column: column,
        range: range,
        compareFunc: (inputRange, rowRange) => rowRange >= inputRange,
      );

  FilterBuilder rangeGteAny(String column, List<String> rangeList) => _filter(
        test: (element) => rangeList.any(
          (range) =>
              RangeType.createRange(range: element[column]) >=
              RangeType.createRange(range: range),
        ),
      );

  FilterBuilder rangeGteAll(String column, List<String> rangeList) => _filter(
        test: (element) => rangeList.every(
          (range) =>
              RangeType.createRange(range: element[column]) >=
              RangeType.createRange(range: range),
        ),
      );

  FilterBuilder rangeLt(String column, String range) => _compareRanges(
        column: column,
        range: range,
        compareFunc: (inputRange, rowRange) => rowRange < inputRange,
      );

  FilterBuilder rangeLtAny(String column, List<String> rangeList) => _filter(
        test: (element) => rangeList.any(
          (range) =>
              RangeType.createRange(range: element[column]) <
              RangeType.createRange(range: range),
        ),
      );

  FilterBuilder rangeLtAll(String column, List<String> rangeList) => _filter(
        test: (element) => rangeList.every(
          (range) =>
              RangeType.createRange(range: element[column]) <
              RangeType.createRange(range: range),
        ),
      );

  FilterBuilder rangeLte(String column, String range) => _compareRanges(
        column: column,
        range: range,
        compareFunc: (inputRange, rowRange) => rowRange <= inputRange,
      );

  FilterBuilder rangeLteAny(String column, List<String> rangeList) => _filter(
        test: (element) => rangeList.any(
          (range) =>
              RangeType.createRange(range: element[column]) <=
              RangeType.createRange(range: range),
        ),
      );

  FilterBuilder rangeLteAll(String column, List<String> rangeList) => _filter(
        test: (element) => rangeList.every(
          (range) =>
              RangeType.createRange(range: element[column]) <=
              RangeType.createRange(range: range),
        ),
      );

  FilterBuilder rangeAdjacent(String column, String range) => _compareRanges(
        column: column,
        range: range,
        compareFunc: (inputRange, rowRange) => rowRange.isAdjacent(inputRange),
      );

  FilterBuilder overlaps(String column, Object value) {
    if (value is String) {
      return _compareRanges(
        column: column,
        range: value,
        compareFunc: (inputRange, rowRange) => rowRange.overlaps(inputRange),
      );
    }

    if (value is List) {
      return _filter(test: (element) {
        final data = element[column];

        if (data is List) {
          return value.any((element) => data.contains(element));
        }

        throw Exception(
          'Overlaps must be used in lists when passing a list as argument.',
        );
      });
    }

    throw Exception('Invalid use of overlaps.');
  }

  FilterBuilder strictlyLeftOf(String column, String range) => _compareRanges(
        column: column,
        range: range,
        compareFunc: (inputRange, rowRange) =>
            rowRange.strictlyLeftOf(inputRange),
      );

  FilterBuilder strictlyRightOf(String column, String range) => _compareRanges(
        column: column,
        range: range,
        compareFunc: (inputRange, rowRange) =>
            rowRange.strictlyRightOf(inputRange),
      );

  FilterBuilder doesNotExtendToTheLeftOf(String column, String range) =>
      _compareRanges(
        column: column,
        range: range,
        compareFunc: (inputRange, rowRange) =>
            rowRange.doesNotExtendToTheLeftOf(inputRange),
      );

  FilterBuilder doesNotExtendToTheRightOf(String column, String range) =>
      _compareRanges(
        column: column,
        range: range,
        compareFunc: (inputRange, rowRange) =>
            rowRange.doesNotExtendToTheRightOf(inputRange),
      );

  FilterBuilder textSearch(
    String column,
    String query, {
    String? config,
    TextSearchType? type,
  }) {
    final search = TextSearch(_data);
    final result = search.textSearch(column, query, config: config, type: type);

    return FilterBuilder(result);
  }

  FilterBuilder match(Map<String, dynamic> query) {
    FilterBuilder oldResult = FilterBuilder(_data);

    query.forEach((key, value) {
      oldResult = oldResult.eq(key, value);
    });

    return oldResult;
  }

  FilterBuilder not(String column, String filter, String value) {
    final postrestParser = PostrestSyntaxParser(_data);
    final filterBuilder = postrestParser.executeFilter(
      column: column,
      filterName: filter,
      value: value,
    );
    final filterResult = filterBuilder.execute();

    final newData = _data
        .where(
          (entry) => !filterResult.data.any(
            (excludeEntry) => const MapEquality<String, dynamic>().equals(
              entry,
              excludeEntry,
            ),
          ),
        )
        .toList();

    return FilterBuilder(newData);
  }

  FilterBuilder or(String filters, String? referencedTable) {
    final postrestParser = PostrestSyntaxParser(_data);
    return postrestParser.executeExpression('or($filters)');
  }

  FilterBuilder _notEqualTo(String column, Object? value) {
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

  FilterBuilder _compareRanges({
    required String column,
    required String range,
    required bool Function(RangeType inputRange, RangeType rowRange)
        compareFunc,
  }) {
    final inputRange = RangeType.createRange(range: range);

    return _filter(test: (element) {
      final rowRange = RangeType.createRange(range: element[column]);
      return compareFunc(inputRange, rowRange);
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

  dynamic _parseBaseTypes(String value) {
    final newValue = value.trim();
    final numParse = num.tryParse(newValue);
    if (numParse != null) {
      return numParse;
    }

    if (['true', 'false'].contains(newValue)) {
      return newValue == 'true' ? true : false;
    }

    if (value == 'null') {
      return null;
    }

    final dateTimeParse = DateTime.tryParse(newValue);
    if (dateTimeParse != null) {
      return dateTimeParse;
    }

    return newValue.replaceAll('\'', '"').replaceAll('"', '');
  }

  void _setError({
    required String message,
    required String code,
    String? details,
    String? hint,
  }) {
    _errorStack.add(
      FilterError(
        message: message,
        code: code,
        detais: details,
        hint: hint,
      ),
    );
  }
}

class FilterResult {
  final bool isValid;
  final FilterError? error;
  final List<Map<String, dynamic>> data;

  FilterResult({
    required this.isValid,
    this.error,
    List<Map<String, dynamic>>? rows,
  }) : data = List<Map<String, dynamic>>.from(rows ?? []);
}

class FilterError {
  final String message;
  final String code;
  final String? detais;
  final String? hint;

  const FilterError({
    required this.message,
    required this.code,
    this.detais,
    this.hint,
  });
}
