import 'package:collection/collection.dart';
import 'package:supabase_flutter/src/testing/filters/filter_type_caster.dart';
import 'package:supabase_flutter/src/testing/postgrest/supabase_test_postgrest.dart';
import 'package:supabase_flutter/src/testing/range_type/range_comparable.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum FilterModifier {
  any('any'),
  all('all');

  final String stringName;

  const FilterModifier(this.stringName);
}

class FilterBuilder {
  final List<Map<String, dynamic>> _data;
  final List<FilterError> _errorStack;
  final FilterTypeCaster _typeCaster = FilterTypeCaster();
  final PostrestSyntaxParser _syntaxParser = PostrestSyntaxParser([]);

  FilterBuilder(List<Map<String, dynamic>> data, {List<FilterError>? errors})
      : _data = List.from(data),
        _errorStack = List.from(errors ?? []);

  FilterResult execute() => FilterResult(
        isValid: _errorStack.isEmpty,
        error: _errorStack.isNotEmpty ? _errorStack.last : null,
        rows: _data,
      );

  FilterBuilder eq(String column, Object value) {
    return FilterBuilder(
      _data.where((element) {
        final castResult = _typeCaster.cast(element[column], value);

        if (!castResult.wasSucessful) {
          _setCastError(castResult.baseValue, castResult.castValue, 'eq');
          return true;
        }

        if (castResult.baseValue is List && castResult.castValue is List) {
          return const DeepCollectionEquality()
              .equals(castResult.baseValue, castResult.castValue);
        }

        if (castResult.baseValue is Map && castResult.castValue is Map) {
          return const MapEquality()
              .equals(castResult.baseValue, castResult.castValue);
        }

        return castResult.baseValue == castResult.castValue;
      }).toList(),
      errors: _errorStack,
    );
  }

  FilterBuilder eqAny(String column, Object value) =>
      _eqModifier(column, value, FilterModifier.any);

  FilterBuilder eqAll(String column, Object value) =>
      _eqModifier(column, value, FilterModifier.all);

  FilterBuilder _eqModifier(
      String column, Object value, FilterModifier modifier) {
    return FilterBuilder(
      _data.where((element) {
        final castResult = _typeCaster.cast(
          element[column],
          value,
          baseAsArrayCaster: true,
        );

        if (castResult.baseValue is List) {
          _setNotScalarValueError(castResult.baseValue);
          return true;
        }

        if (castResult.castValue is! List) {
          _setMalformedLiteralError(value, 'array');
          return true;
        }

        if (!castResult.wasSucessful) {
          _setCastError(
            castResult.baseValue,
            castResult.castValue,
            'eq(${modifier.stringName})',
          );
          return true;
        }

        if (castResult.castValue.isNotEmpty &&
            castResult.castValue.first is Map) {
          if (modifier == FilterModifier.all) {
            return castResult.castValue.every(
              (map) => const MapEquality().equals(map, castResult.baseValue),
            );
          } else if (modifier == FilterModifier.any) {
            return castResult.castValue.any(
              (map) => const MapEquality().equals(map, castResult.baseValue),
            );
          } else {
            throw Exception('Unknown modifier');
          }
        }

        if (modifier == FilterModifier.all) {
          return castResult.castValue
              .every((castElement) => castResult.baseValue == castElement);
        } else if (modifier == FilterModifier.any) {
          return castResult.castValue.contains(castResult.baseValue);
        } else {
          throw Exception('Unknown modifier');
        }
      }).toList(),
      errors: _errorStack,
    );
  }

  FilterBuilder neq(String column, Object value) => _notEqualTo(column, value);

  FilterBuilder isDistinct(String column, Object? value) =>
      _notEqualTo(column, value);

  FilterBuilder gt(String column, Object value) => _compare(
        column: column,
        value: value,
        filterLabel: 'gt',
        compareFunc: (compareResult) => compareResult > 0,
      );

  FilterBuilder gtAny(String column, Object values) => _compare(
        column: column,
        value: values,
        filterLabel: 'gt(any)',
        modifier: FilterModifier.any,
        compareFunc: (compareResult) => compareResult > 0,
      );

  FilterBuilder gtAll(String column, Object values) => _compare(
        column: column,
        value: values,
        filterLabel: 'gt(all)',
        modifier: FilterModifier.all,
        compareFunc: (compareResult) => compareResult > 0,
      );

  FilterBuilder gte(String column, Object value) => _compare(
        column: column,
        value: value,
        filterLabel: 'gte',
        compareFunc: (compareResult) => compareResult >= 0,
      );

  FilterBuilder gteAny(String column, Object values) => _compare(
        column: column,
        value: values,
        filterLabel: 'gte(any)',
        modifier: FilterModifier.any,
        compareFunc: (compareResult) => compareResult >= 0,
      );

  FilterBuilder gteAll(String column, Object values) => _compare(
        column: column,
        value: values,
        filterLabel: 'gte(all)',
        modifier: FilterModifier.all,
        compareFunc: (compareResult) => compareResult >= 0,
      );

  FilterBuilder lt(String column, Object value) => _compare(
        column: column,
        value: value,
        filterLabel: 'lt',
        compareFunc: (compareResult) => compareResult < 0,
      );

  FilterBuilder ltAny(String column, Object values) => _compare(
        column: column,
        value: values,
        filterLabel: 'lt(any)',
        modifier: FilterModifier.any,
        compareFunc: (compareResult) => compareResult < 0,
      );

  FilterBuilder ltAll(String column, Object values) => _compare(
        column: column,
        value: values,
        filterLabel: 'lt(all)',
        modifier: FilterModifier.all,
        compareFunc: (compareResult) => compareResult < 0,
      );

  FilterBuilder lte(String column, Object value) => _compare(
        column: column,
        value: value,
        filterLabel: 'lte',
        compareFunc: (compareResult) => compareResult <= 0,
      );

  FilterBuilder lteAny(String column, Object values) => _compare(
        column: column,
        value: values,
        filterLabel: 'lte(any)',
        modifier: FilterModifier.any,
        compareFunc: (compareResult) => compareResult <= 0,
      );

  FilterBuilder lteAll(String column, Object values) => _compare(
        column: column,
        value: values,
        filterLabel: 'lte(all)',
        modifier: FilterModifier.all,
        compareFunc: (compareResult) => compareResult <= 0,
      );

  FilterBuilder _compare({
    required String column,
    required Object value,
    required String filterLabel,
    required bool Function(int compareResult) compareFunc,
    FilterModifier? modifier,
  }) =>
      FilterBuilder(
        _data.where((element) {
          final castResult = _typeCaster.cast(
            element[column],
            value,
            baseAsArrayCaster: modifier == null ? false : true,
          );
          final baseValue = castResult.baseValue;
          final castValue = castResult.castValue;

          if (modifier != null) {
            if (castResult.baseValue is List) {
              _setNotScalarValueError(castResult.baseValue);
              return true;
            }

            if (castResult.castValue is! List) {
              _setMalformedLiteralError(value, 'array');
              return true;
            }
          }

          if (!castResult.wasSucessful) {
            _setCastError(baseValue, castValue, filterLabel);
            return true;
          }

          if (modifier == FilterModifier.any) {
            return castValue.any((castElement) =>
                compareFunc(_compareValuesBasedOnType(baseValue, castElement)));
          } else if (modifier == FilterModifier.all) {
            return castValue.every((castElement) =>
                compareFunc(_compareValuesBasedOnType(baseValue, castElement)));
          } else {
            return compareFunc(_compareValuesBasedOnType(baseValue, castValue));
          }
        }).toList(),
        errors: _errorStack,
      );

  int _compareDateTime(DateTime value1, DateTime value2) {
    if (value1.isAfter(value2)) {
      return 1;
    } else if (value1.isAtSameMomentAs(value2)) {
      return 0;
    } else {
      return -1;
    }
  }

  int _compareString(String value1, String value2) => value1.compareTo(value2);

  int _compareBool(bool value1, bool value2) {
    final integer1 = value1 ? 1 : 0;
    final integer2 = value2 ? 1 : 0;
    if (integer1 > integer2) {
      return 1;
    } else if (integer1 == integer2) {
      return 0;
    } else {
      return -1;
    }
  }

  int _compareMap(Map value1, Map value2) {
    final cast1 = value1.toString();
    final cast2 = value2.toString();

    return cast1.compareTo(cast2);
  }

  int _compareRange(RangeType range1, RangeType range2) {
    final comparable1 = range1.getComparable();
    final comparable2 = range2.getComparable();

    if (comparable1 > comparable2) {
      return 1;
    } else if (comparable1 == comparable2) {
      return 0;
    } else {
      return -1;
    }
  }

  int _compareValuesBasedOnType(dynamic value1, dynamic value2) {
    if (value1 is String && value2 is String) {
      return _compareString(value1, value2);
    } else if (value1 is DateTime && value2 is DateTime) {
      return _compareDateTime(value1, value2);
    } else if (value1 is bool && value2 is bool) {
      return _compareBool(value1, value2);
    } else if (value1 is List && value2 is List) {
      return _compareLists(value1, value2);
    } else if (value1 is Map && value2 is Map) {
      return _compareMap(value1, value2);
    } else if (value1 is RangeType && value2 is RangeType) {
      return _compareRange(value1, value2);
    } else {
      return value1.compareTo(value2);
    }
  }

  int _compareLists(List list1, List list2) {
    final minLength = list1.length < list2.length ? list1.length : list2.length;
    for (int i = 0; i < minLength; i++) {
      final baseValue = list1[i];
      final castValue = list2[i];

      final comparison = _compareValuesBasedOnType(baseValue, castValue);
      if (comparison != 0) {
        return comparison;
      }
    }
    return list1.length.compareTo(list2.length);
  }

  FilterBuilder _matchPattern({
    required String column,
    required Object pattern,
    required bool caseSensitive,
    FilterModifier? modifier,
  }) =>
      FilterBuilder(
        _data.where((element) {
          final baseValue = element[column];

          if (baseValue is! String) {
            _setOperatorDoesNotExistError(baseValue, '~~');
            return true;
          }

          if (modifier != null) {
            final parsedPattern = pattern is String
                ? _syntaxParser.parseValue(pattern.toString())
                : pattern;
            if (parsedPattern is! List) {
              _setMalformedLiteralError(parsedPattern, 'array');
              return true;
            }

            final patternStringList =
                parsedPattern.map((e) => e.toString()).toList();

            if (modifier == FilterModifier.any) {
              return patternStringList.any(
                (patternString) => _like(
                  baseValue,
                  patternString,
                  caseSensitive: caseSensitive,
                ),
              );
            } else if (modifier == FilterModifier.all) {
              return patternStringList.every(
                (patternString) => _like(
                  baseValue,
                  patternString,
                  caseSensitive: caseSensitive,
                ),
              );
            } else {
              throw Exception('Unknown modifier');
            }
          }

          return _like(
            baseValue,
            pattern.toString(),
            caseSensitive: caseSensitive,
          );
        }).toList(),
        errors: _errorStack,
      );

  FilterBuilder like(String column, Object pattern) => _matchPattern(
        column: column,
        pattern: pattern,
        caseSensitive: true,
      );

  FilterBuilder ilike(String column, Object pattern) => _matchPattern(
        column: column,
        pattern: pattern,
        caseSensitive: false,
      );

  FilterBuilder likeAllOf(String column, Object patterns) => _matchPattern(
        column: column,
        pattern: patterns,
        caseSensitive: true,
        modifier: FilterModifier.all,
      );

  FilterBuilder ilikeAllOf(String column, Object patterns) => _matchPattern(
        column: column,
        pattern: patterns,
        caseSensitive: false,
        modifier: FilterModifier.all,
      );

  FilterBuilder likeAnyOf(String column, Object patterns) => _matchPattern(
        column: column,
        pattern: patterns,
        caseSensitive: true,
        modifier: FilterModifier.any,
      );

  FilterBuilder ilikeAnyOf(String column, Object patterns) => _matchPattern(
        column: column,
        pattern: patterns,
        caseSensitive: false,
        modifier: FilterModifier.any,
      );

  FilterBuilder isFilter(String column, Object? value) => FilterBuilder(
        _data.where((element) {
          final castResult = _typeCaster.cast(
            element[column],
            value,
          );

          final baseValue = castResult.baseValue;
          final castValue = castResult.castValue;

          if (baseValue is! bool) {
            if (castValue is bool || castValue == null) {
              _setInvalidIsArgumentError(baseValue);
              return true;
            }
            _setFailedToParseIsFilterError(castValue);
            return true;
          }

          if (castValue is! bool && castValue != null) {
            _setFailedToParseIsFilterError(castValue);
            return true;
          }

          return baseValue == castValue;
        }).toList(),
        errors: _errorStack,
      );

  FilterBuilder inFilter(String column, Object value) => eqAny(column, value);

  FilterBuilder contains(String column, Object value) =>
      _contains(column, value, false);

  FilterBuilder containedBy(String column, Object value) =>
      _contains(column, value, true);

  FilterBuilder rangeAdjacent(String column, Object range) => _compareRanges(
        column: column,
        range: range,
        operatorStr: '-|-',
        compareFunc: (baseRange, castRange) => baseRange.isAdjacent(castRange),
      );

  FilterBuilder overlaps(String column, Object value) => FilterBuilder(
        _data.where((element) {
          final castResult = _typeCaster.cast(
            element[column],
            value,
          );

          final baseValue = castResult.baseValue;
          final castValue = castResult.castValue;

          if (baseValue is! RangeType && baseValue is! List) {
            _setOperatorDoesNotExistError(
              baseValue,
              '&&',
            );
            return true;
          }

          if (!castResult.wasSucessful) {
            _setMalformedLiteralError(castValue, 'range');
            return true;
          }

          if (baseValue is RangeType) {
            return baseValue.overlaps(castValue);
          }

          if (baseValue is List) {
            return castValue.any((element) => baseValue.contains(element));
          }

          throw Exception('Unknown Error');
        }).toList(),
        errors: _errorStack,
      );

  FilterBuilder rangeLt(String column, Object range) => _compareRanges(
        column: column,
        range: range,
        operatorStr: '<<',
        compareFunc: (baseRange, castRange) =>
            baseRange.strictlyLeftOf(castRange),
      );

  FilterBuilder rangeGt(String column, Object range) => _compareRanges(
        column: column,
        range: range,
        operatorStr: '>>',
        compareFunc: (baseRange, castRange) =>
            baseRange.strictlyRightOf(castRange),
      );

  FilterBuilder rangeGte(String column, Object range) => _compareRanges(
        column: column,
        range: range,
        operatorStr: '&>',
        compareFunc: (baseRange, castRange) =>
            baseRange.doesNotExtendToTheLeftOf(castRange),
      );

  FilterBuilder rangeLte(String column, Object range) => _compareRanges(
        column: column,
        range: range,
        operatorStr: '&<',
        compareFunc: (baseRange, castRange) =>
            baseRange.doesNotExtendToTheRightOf(castRange),
      );

  FilterBuilder _compareRanges({
    required String column,
    required Object range,
    required String operatorStr,
    required bool Function(
      RangeType baseRange,
      RangeType castRange,
    ) compareFunc,
  }) =>
      FilterBuilder(
        _data.where((element) {
          final castResult = _typeCaster.cast(
            element[column],
            range,
          );

          final baseValue = castResult.baseValue;
          final castValue = castResult.castValue;

          if (baseValue is! RangeType) {
            if (baseValue is int && ['>>', '<<'].contains(operatorStr)) {
              _setInvalidWhereArgumentError(baseValue);
              return true;
            }
            _setOperatorDoesNotExistError(
              baseValue,
              operatorStr,
            );
            return true;
          }

          if (castValue is! RangeType) {
            _setMalformedLiteralError(castValue, 'range');
            return true;
          }

          return compareFunc(baseValue, castValue);
        }).toList(),
        errors: _errorStack,
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
    return FilterBuilder(
      _data.where((element) {
        final castResult = _typeCaster.cast(element[column], value);

        if (!castResult.wasSucessful) {
          _setCastError(castResult.baseValue, castResult.castValue, 'eq');
        }

        if (castResult.baseValue == List && castResult.castValue == List) {
          return !(const DeepCollectionEquality()
              .equals(castResult.baseValue, castResult.castValue));
        }

        if (castResult.baseValue == Map && castResult.castValue == Map) {
          return !(const MapEquality()
              .equals(castResult.baseValue, castResult.castValue));
        }

        return castResult.baseValue != castResult.castValue;
      }).toList(),
      errors: _errorStack,
    );
  }

  bool _containsRange(RangeType range1, RangeType range2, bool isContainedBy) {
    late final RangeComparable comparable1;
    late final RangeComparable comparable2;

    if (isContainedBy) {
      comparable1 = range1.getComparable();
      comparable2 = range2.getComparable();
    } else {
      comparable1 = range2.getComparable();
      comparable2 = range1.getComparable();
    }

    return comparable2.isInRange(comparable1.lowerRange) &&
        comparable2.isInRange(comparable1.upperRange);
  }

  bool _containsList(dynamic value1, dynamic value2, bool isContainedBy) {
    if (value1 is List) {
      if (isContainedBy) {
        return value1.every((element) => value2.contains(element));
      }

      return value2.every((element) => value1.contains(element));
    }

    if (isContainedBy) {
      return value2.any((element) => element == value1);
    }

    return value2.every((element) => element == value1);
  }

  bool _containsMap(dynamic value1, dynamic value2, bool isContainedBy) {
    if (isContainedBy) {
      return _containsMapOperation(value2, value1);
    }
    return _containsMapOperation(value1, value2);
  }

  bool _containsMapOperation(Map thisMap, Map other) => other.entries.every(
        (element) =>
            thisMap.containsKey(element.key) &&
            thisMap.containsValue(element.value),
      );

  FilterBuilder _contains(String column, Object value, bool isContainedBy) =>
      FilterBuilder(
        _data.where((element) {
          final castResult = _typeCaster.cast(
            element[column],
            value,
          );

          final baseValue = castResult.baseValue;
          final castValue = castResult.castValue;

          if (baseValue is! RangeType &&
              baseValue is! List &&
              baseValue is! Map) {
            _setOperatorDoesNotExistError(
              baseValue,
              isContainedBy ? '<@' : '@>',
            );
            return true;
          }

          if (!castResult.wasSucessful) {
            _setMalformedLiteralError(castValue, 'range');
            return true;
          }

          if (baseValue is RangeType) {
            return _containsRange(baseValue, castValue, isContainedBy);
          }

          if (baseValue is List) {
            return _containsList(baseValue, castValue, isContainedBy);
          }

          if (baseValue is Map) {
            return _containsMap(baseValue, castValue, isContainedBy);
          }

          throw Exception('Unknown Error');
        }).toList(),
        errors: _errorStack,
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

  void _setMalformedLiteralError(dynamic castType, String literalName) {
    _setError(
      message: 'malformed $literalName literal: "${castType.toString()}"',
      code: '22P02',
      details: 'Array value must start with "{" or dimension information.',
      hint: null,
    );
  }

  void _setNotScalarValueError(dynamic baseType) {
    _setError(
      message:
          'could not find array type for data type ${_getTypeString(baseType)}[]',
      code: '42704',
      details: 'Bad Request',
      hint: null,
    );
  }

  void _setOperatorDoesNotExistError(dynamic baseType, String operatorStr) {
    _setError(
      message:
          'operator does not exist: ${_getTypeString(baseType)}${baseType is List ? '[]' : ''} $operatorStr unknown',
      code: '42883',
      details: 'Not Found',
      hint:
          'No operator matches the given name and argument types. You might need to add explicit type casts.',
    );
  }

  void _setInvalidWhereArgumentError(dynamic baseType) {
    _setError(
      message:
          'argument of WHERE must be type boolean, not type ${_getTypeString(baseType)}',
      code: '42804',
      details: 'Bad Request',
      hint: null,
    );
  }

  void _setFailedToParseIsFilterError(dynamic castValue) {
    _setError(
      message:
          '"failed to parse filter (is.${castValue.toString()})" (line 1, column 4)',
      code: 'PGRST100',
      details:
          'unexpected "${castValue.toString()[0]}" expecting null or trilean value (unknown, true, false)',
      hint: null,
    );
  }

  void _setInvalidIsArgumentError(dynamic baseType) {
    _setError(
      message:
          'argument of IS TRUE must be type boolean, not type ${_getTypeString(baseType)}',
      code: '42804',
      details: 'Bad Request',
      hint: null,
    );
  }

  String _getTypeString(dynamic value) {
    final dynamic type = _getListFirstElement(value);

    if (type is int) {
      return 'int';
    } else if (type is double) {
      return 'double precision';
    } else if (type is String) {
      return 'text';
    } else if (type is bool) {
      return 'boolean';
    } else if (type is DateTime) {
      return 'timestamp with time zone';
    } else if (type is RangeType) {
      return 'range';
    } else if (type is Map) {
      return 'jsonb';
    } else if (type == null) {
      return 'null or empty list';
    } else {
      return 'unknown type';
    }
  }

  dynamic _getListFirstElement(dynamic value) {
    if (value is List) {
      if (value.isEmpty) {
        return null;
      } else {
        return value.first;
      }
    } else {
      return value;
    }
  }

  void _setCastError(dynamic baseType, dynamic castType, String filter) {
    final valueString = castType is List
        ? ['eq(any)', 'eq(all)'].contains(filter) && castType.isNotEmpty
            ? castType.first
            : _toPostgresList(castType.toString())
        : castType.toString();
    if (baseType is int) {
      _setError(
        message: 'invalid input syntax for type int: "$valueString"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );
    } else if (baseType is double) {
      _setError(
        message:
            'invalid input syntax for type double precision: "$valueString"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );
    } else if (baseType is bool) {
      _setError(
        message: 'invalid input syntax for type boolean: "$valueString"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );
    } else if (baseType is DateTime) {
      if (castType is int) {
        _setError(
          message: 'date/time field value out of range: "$valueString"',
          code: '22008',
          details: 'Bad Request',
          hint: 'Perhaps you need a different "datestyle" setting',
        );
      } else {
        _setError(
          message:
              'invalid input syntax for type timestamp with time zone: "$valueString"',
          code: '22007',
          details: 'Bad Request',
          hint: null,
        );
      }
    } else if (baseType is RangeType) {
      _setError(
        message: 'malformed range literal: "$valueString"',
        code: '22P02',
        details: 'Missing left parenthesis or bracket.',
        hint: null,
      );
    } else if (baseType is List) {
      if (baseType.first is int) {
        if (castType is List) {
          _setError(
            message: 'invalid input syntax for type int: "${castType.first}"',
            code: '22P02',
            details: 'Bad Request',
            hint: null,
          );
        } else {
          _setError(
            message: 'malformed array literal: "$valueString"',
            code: '22P02',
            details:
                'Array value must start with "{" or dimension information.',
            hint: null,
          );
        }
      } else if (baseType.first is double) {
        if (castType is List) {
          _setError(
            message:
                'invalid input syntax for type double precision: "${castType.first}"',
            code: '22P02',
            details: 'Bad Request',
            hint: null,
          );
        } else {
          _setError(
            message: 'malformed array literal: "$valueString"',
            code: '22P02',
            details:
                'Array value must start with "{" or dimension information.',
            hint: null,
          );
        }
      } else if (baseType.first is String) {
        _setError(
          message: 'malformed array literal: "$valueString"',
          code: '22P02',
          details: 'Array value must start with "{" or dimension information.',
          hint: null,
        );
      } else if (baseType.first is bool) {
        if (castType is List) {
          _setError(
            message:
                'invalid input syntax for type boolean: "${castType.first}"',
            code: '22P02',
            details: 'Bad Request',
            hint: null,
          );
        } else {
          _setError(
            message: 'malformed array literal: "$valueString"',
            code: '22P02',
            details:
                'Array value must start with "{" or dimension information.',
            hint: null,
          );
        }
      } else if (baseType.first is DateTime) {
        if (castType is List) {
          _setError(
            message:
                'invalid input syntax for type timestamp with time zone: "${castType.first}"',
            code: '22P02',
            details: 'Bad Request',
            hint: null,
          );
        } else {
          _setError(
            message: 'malformed array literal: "$valueString"',
            code: '22P02',
            details:
                'Array value must start with "{" or dimension information.',
            hint: null,
          );
        }
      } else if (baseType.first is RangeType) {
        if (castType is List) {
          _setError(
            message: 'malformed range literal: "${castType.first}"',
            code: '22P02',
            details: 'Bad Request',
            hint: null,
          );
        } else {
          _setError(
            message: ' malformed array literal: "$valueString"',
            code: '22P02',
            details:
                'Array value must start with "{" or dimension information.',
            hint: null,
          );
        }
      } else if (baseType.first is Map) {
        _setError(
          message: ' malformed array literal: "$valueString"',
          code: '22P02',
          details: 'Array value must start with "{" or dimension information.',
          hint: null,
        );
      }
    }
  }

  String _toPostgresList(String listString) {
    final elements = listString.substring(
      listString.firstIndex! + 1,
      listString.lastIndex,
    );
    return '{$elements}';
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
        details: details,
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
  final String? details;
  final String? hint;

  const FilterError({
    required this.message,
    required this.code,
    this.details,
    this.hint,
  });

  @override
  String toString() =>
      'message: $message, code: $code, details: $details, hint: $hint';
}
