import 'package:collection/collection.dart';
import 'package:supabase_flutter/src/testing/filters/filter_errors.dart';
import 'package:supabase_flutter/src/testing/filters/filter_type_caster.dart';
import 'package:supabase_flutter/src/testing/postgrest/supabase_test_postgrest.dart';
import 'package:supabase_flutter/src/testing/range_type/range_comparable.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';
import 'package:supabase_flutter/src/testing/utils/value_comparator.dart';
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
  final FilterBuilderErrors _errors = FilterBuilderErrors();
  final ValueComparator _comparator = ValueComparator();
  final _deepEq = const DeepCollectionEquality().equals;
  final _mapEq = const MapEquality().equals;

  FilterBuilder(List<Map<String, dynamic>> data, {List<FilterError>? errors})
      : _data = List.from(data),
        _errorStack = List.from(errors ?? []);

  FilterResult execute() => FilterResult(
        isValid: _errorStack.isEmpty,
        error: _errorStack.isNotEmpty ? _errorStack.last : null,
        rows: _data,
      );

  FilterBuilder eq(String column, Object value) => _complexSpecificFilter(
        column: column,
        value: value,
        listFunc: (baseList, castList) => _deepEq(baseList, castList),
        mapFunc: (baseMap, castMap) => _mapEq(baseMap, castMap),
        baseFunc: (baseValue, castValue) => baseValue == castValue,
        customErrorCallback: (baseValue, castValue) {
          if (baseValue is DateTime && castValue is int) {
            return _setError(_errors.datetimeOutOfRange(castValue));
          }

          if (baseValue is List && castValue is List) {
            if (baseValue.isNotEmpty && castValue.isNotEmpty) {
              final firstBase = baseValue.first;
              final firstCast = castValue.first;

              if (firstBase is RangeType && firstCast is! RangeType) {
                return _setError(
                  _errors.malformedLiteralError(castValue, 'range'),
                );
              }
            }
          }
          return null;
        },
      );

  FilterBuilder neq(String column, Object value) => _complexSpecificFilter(
        column: column,
        value: value,
        listFunc: (baseList, castList) => !(_deepEq(baseList, castList)),
        mapFunc: (baseMap, castMap) => !(_mapEq(baseMap, castMap)),
        baseFunc: (baseValue, castValue) => baseValue != castValue,
      );

  FilterBuilder isDistinct(String column, Object? value) =>
      _complexSpecificFilter(
        column: column,
        value: value,
        listFunc: (baseList, castList) => !(_deepEq(baseList, castList)),
        mapFunc: (baseMap, castMap) => !(_mapEq(baseMap, castMap)),
        baseFunc: (baseValue, castValue) => baseValue != castValue,
      );

  FilterBuilder eqAny(String column, Object value) =>
      _complexSpecificModifierFilter(
        column: column,
        value: value,
        modifier: FilterModifier.any,
        listFunc: (baseList, castList) => _deepEq(castList, baseList),
        mapFunc: (baseMap, castMap) => _mapEq(castMap, baseMap),
        baseFunc: (baseValue, castValue) => baseValue == castValue,
      );

  FilterBuilder eqAll(String column, Object value) =>
      _complexSpecificModifierFilter(
        column: column,
        value: value,
        modifier: FilterModifier.all,
        listFunc: (baseList, castList) => _deepEq(castList, baseList),
        mapFunc: (baseMap, castMap) => _mapEq(castMap, baseMap),
        baseFunc: (baseValue, castValue) => baseValue == castValue,
      );

  FilterBuilder gt(String column, Object value) => _complexSpecificFilter(
        column: column,
        value: value,
        baseFunc: (baseValue, castValue) =>
            _comparator.compareValues(baseValue, castValue) > 0,
      );

  FilterBuilder gtAny(String column, Object values) =>
      _complexSpecificModifierFilter(
        column: column,
        value: values,
        modifier: FilterModifier.any,
        baseFunc: (baseValue, castValue) =>
            _comparator.compareValues(baseValue, castValue) > 0,
      );

  FilterBuilder gtAll(String column, Object values) =>
      _complexSpecificModifierFilter(
        column: column,
        value: values,
        modifier: FilterModifier.all,
        baseFunc: (baseValue, castValue) =>
            _comparator.compareValues(baseValue, castValue) > 0,
      );

  FilterBuilder gte(String column, Object value) => _complexSpecificFilter(
        column: column,
        value: value,
        baseFunc: (baseValue, castValue) =>
            _comparator.compareValues(baseValue, castValue) >= 0,
      );

  FilterBuilder gteAny(String column, Object values) =>
      _complexSpecificModifierFilter(
        column: column,
        value: values,
        modifier: FilterModifier.any,
        baseFunc: (baseValue, castValue) =>
            _comparator.compareValues(baseValue, castValue) >= 0,
      );

  FilterBuilder gteAll(String column, Object values) =>
      _complexSpecificModifierFilter(
        column: column,
        value: values,
        modifier: FilterModifier.all,
        baseFunc: (baseValue, castValue) =>
            _comparator.compareValues(baseValue, castValue) >= 0,
      );

  FilterBuilder lt(String column, Object value) => _complexSpecificFilter(
        column: column,
        value: value,
        baseFunc: (baseValue, castValue) =>
            _comparator.compareValues(baseValue, castValue) < 0,
      );

  FilterBuilder ltAny(String column, Object values) =>
      _complexSpecificModifierFilter(
        column: column,
        value: values,
        modifier: FilterModifier.any,
        baseFunc: (baseValue, castValue) =>
            _comparator.compareValues(baseValue, castValue) < 0,
      );

  FilterBuilder ltAll(String column, Object values) =>
      _complexSpecificModifierFilter(
        column: column,
        value: values,
        modifier: FilterModifier.all,
        baseFunc: (baseValue, castValue) =>
            _comparator.compareValues(baseValue, castValue) < 0,
      );

  FilterBuilder lte(String column, Object value) => _complexSpecificFilter(
        column: column,
        value: value,
        baseFunc: (baseValue, castValue) =>
            _comparator.compareValues(baseValue, castValue) <= 0,
      );

  FilterBuilder lteAny(String column, Object values) =>
      _complexSpecificModifierFilter(
        column: column,
        value: values,
        modifier: FilterModifier.any,
        baseFunc: (baseValue, castValue) =>
            _comparator.compareValues(baseValue, castValue) <= 0,
      );

  FilterBuilder lteAll(String column, Object values) =>
      _complexSpecificModifierFilter(
        column: column,
        value: values,
        modifier: FilterModifier.all,
        baseFunc: (baseValue, castValue) =>
            _comparator.compareValues(baseValue, castValue) <= 0,
      );

  FilterBuilder like(String column, Object pattern) => _patternMatchingFilter(
        column: column,
        pattern: pattern,
        caseSensitive: true,
      );

  FilterBuilder ilike(String column, Object pattern) => _patternMatchingFilter(
        column: column,
        pattern: pattern,
        caseSensitive: false,
      );

  FilterBuilder likeAllOf(String column, Object patterns) =>
      _patternMatchingFilter(
        column: column,
        pattern: patterns,
        caseSensitive: true,
        modifier: FilterModifier.all,
      );

  FilterBuilder ilikeAllOf(String column, Object patterns) =>
      _patternMatchingFilter(
        column: column,
        pattern: patterns,
        caseSensitive: false,
        modifier: FilterModifier.all,
      );

  FilterBuilder likeAnyOf(String column, Object patterns) =>
      _patternMatchingFilter(
        column: column,
        pattern: patterns,
        caseSensitive: true,
        modifier: FilterModifier.any,
      );

  FilterBuilder ilikeAnyOf(String column, Object patterns) =>
      _patternMatchingFilter(
        column: column,
        pattern: patterns,
        caseSensitive: false,
        modifier: FilterModifier.any,
      );

  FilterBuilder isFilter(String column, Object? value) =>
      _complexSpecificFilter(
        column: column,
        value: value,
        allowedTypeFunc: (baseValue, castValue) {
          if (baseValue is! bool && baseValue != null) {
            if (castValue is bool || castValue == null) {
              return _setError(_errors.invalidArgumentError(
                baseValue,
                'IS ${castValue == true ? 'TRUE' : 'FALSE'}',
              ));
            }
            return _setError(_errors.failedToParseIsFilterError(castValue));
          }

          if (castValue is! bool && castValue != null) {
            return _setError(_errors.failedToParseIsFilterError(castValue));
          }
          return null;
        },
        baseFunc: (baseValue, castValue) => baseValue == castValue,
      );

  FilterBuilder inFilter(String column, Object value) => eqAny(column, value);

  FilterBuilder contains(String column, Object value) => _complexSpecificFilter(
        column: column,
        value: value,
        allowedTypeFunc: (baseValue, castValue) {
          if (baseValue is! RangeType &&
              baseValue is! List &&
              baseValue is! Map) {
            return _setError(
              _errors.operatorDoesNotExistError(baseValue, '@>'),
            );
          }
          return null;
        },
        rangeFunc: (baseRange, castRange) =>
            _containsRange(baseRange, castRange, false),
        listFunc: (baseList, castList) =>
            _containsList(baseList, castList, false),
        mapFunc: (baseMap, castMap) => _containsMap(baseMap, castMap, false),
        baseFunc: (baseValue, castValue) {
          throw Exception('Unknown error');
        },
      );

  FilterBuilder containedBy(String column, Object value) =>
      _complexSpecificFilter(
        column: column,
        value: value,
        allowedTypeFunc: (baseValue, castValue) {
          if (baseValue is! RangeType &&
              baseValue is! List &&
              baseValue is! Map) {
            return _setError(
              _errors.operatorDoesNotExistError(baseValue, '<@'),
            );
          }
          return null;
        },
        rangeFunc: (baseRange, castRange) =>
            _containsRange(baseRange, castRange, true),
        listFunc: (baseList, castList) =>
            _containsList(baseList, castList, true),
        mapFunc: (baseMap, castMap) => _containsMap(baseMap, castMap, true),
        baseFunc: (baseValue, castValue) {
          throw Exception('Unknown error');
        },
      );

  FilterBuilder rangeAdjacent(String column, Object range) =>
      _complexSpecificFilter(
        column: column,
        value: range,
        allowedTypeFunc: (baseValue, castValue) {
          if (baseValue is! RangeType) {
            return _setError(
              _errors.operatorDoesNotExistError(baseValue, '-|-'),
            );
          }

          if (castValue is! RangeType) {
            return _setError(_errors.malformedLiteralError(castValue, 'range'));
          }
          return null;
        },
        baseFunc: (baseRange, castRange) => baseRange.isAdjacent(castRange),
      );

  FilterBuilder overlaps(String column, Object value) => _complexSpecificFilter(
        column: column,
        value: value,
        allowedTypeFunc: (baseValue, castValue) {
          if (baseValue is! RangeType && baseValue is! List) {
            return _setError(
              _errors.operatorDoesNotExistError(baseValue, '&&'),
            );
          }
          return null;
        },
        rangeFunc: (baseRange, castRange) => baseRange.overlaps(castRange),
        listFunc: (baseList, castList) =>
            castList.any((element) => baseList.contains(element)),
        baseFunc: (baseValue, castValue) => throw Exception('Unknown Error'),
      );

  FilterBuilder rangeLt(String column, Object range) => _complexSpecificFilter(
        column: column,
        value: range,
        allowedTypeFunc: (baseValue, castValue) {
          if (baseValue is! RangeType) {
            if (baseValue is int) {
              return _setError(
                _errors.invalidArgumentError(baseValue, 'WHERE'),
              );
            }
            return _setError(
              _errors.operatorDoesNotExistError(baseValue, '<<'),
            );
          }

          if (castValue is! RangeType) {
            return _setError(_errors.malformedLiteralError(castValue, 'range'));
          }
          return null;
        },
        baseFunc: (baseRange, castRange) => baseRange.strictlyLeftOf(castRange),
      );

  FilterBuilder rangeGt(String column, Object range) => _complexSpecificFilter(
        column: column,
        value: range,
        allowedTypeFunc: (baseValue, castValue) {
          if (baseValue is! RangeType) {
            if (baseValue is int) {
              return _setError(
                _errors.invalidArgumentError(baseValue, 'WHERE'),
              );
            }
            return _setError(
              _errors.operatorDoesNotExistError(baseValue, '>>'),
            );
          }

          if (castValue is! RangeType) {
            return _setError(_errors.malformedLiteralError(castValue, 'range'));
          }
          return null;
        },
        baseFunc: (baseRange, castRange) =>
            baseRange.strictlyRightOf(castRange),
      );

  FilterBuilder rangeGte(String column, Object range) => _complexSpecificFilter(
        column: column,
        value: range,
        allowedTypeFunc: (baseValue, castValue) {
          if (baseValue is! RangeType) {
            return _setError(
              _errors.operatorDoesNotExistError(baseValue, '&>'),
            );
          }

          if (castValue is! RangeType) {
            return _setError(_errors.malformedLiteralError(castValue, 'range'));
          }
          return null;
        },
        baseFunc: (baseRange, castRange) =>
            baseRange.doesNotExtendToTheLeftOf(castRange),
      );

  FilterBuilder rangeLte(String column, Object range) => _complexSpecificFilter(
        column: column,
        value: range,
        allowedTypeFunc: (baseValue, castValue) {
          if (baseValue is! RangeType) {
            return _setError(
              _errors.operatorDoesNotExistError(baseValue, '&<'),
            );
          }

          if (castValue is! RangeType) {
            return _setError(_errors.malformedLiteralError(castValue, 'range'));
          }
          return null;
        },
        baseFunc: (baseRange, castRange) =>
            baseRange.doesNotExtendToTheRightOf(castRange),
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

  FilterBuilder _complexSpecificFilter({
    required String column,
    required Object? value,
    bool? Function(dynamic baseValue, dynamic castValue)? allowedTypeFunc,
    bool? Function(dynamic baseValue, dynamic castValue)? customErrorCallback,
    bool Function(List baseList, List castList)? listFunc,
    bool Function(Map baseMap, Map castMap)? mapFunc,
    bool Function(RangeType baseRange, RangeType castRange)? rangeFunc,
    required bool Function(dynamic baseValue, dynamic castValue) baseFunc,
  }) =>
      FilterBuilder(
        _data.where((element) {
          final castResult = _typeCaster.cast(element[column], value);
          final baseValue = castResult.baseValue;
          final castValue = castResult.castValue;

          if (allowedTypeFunc != null) {
            final result = allowedTypeFunc(baseValue, castValue);
            if (result != null) {
              return result;
            }
          }

          if (!castResult.wasSucessful) {
            if (customErrorCallback != null) {
              final result = customErrorCallback(baseValue, castValue);
              if (result != null) {
                return result;
              }
            }

            if (baseValue is RangeType) {
              return _setError(
                _errors.malformedLiteralError(castValue, 'range'),
              );
            }

            if (baseValue is List) {
              if (castValue is! List) {
                return _setError(
                  _errors.malformedLiteralError(castValue, 'array'),
                );
              } else {
                return _setError(
                  _errors.invalidInputSyntaxError(baseValue, castValue, true),
                );
              }
            }

            return _setError(
              _errors.invalidInputSyntaxError(baseValue, castValue, false),
            );
          }

          if (baseValue is List && castValue is List && listFunc != null) {
            return listFunc(baseValue, castValue);
          }

          if (baseValue is Map && castValue is Map && mapFunc != null) {
            return mapFunc(baseValue, castValue);
          }

          if (baseValue is RangeType &&
              castValue is RangeType &&
              rangeFunc != null) {
            return rangeFunc(baseValue, castValue);
          }

          return baseFunc(baseValue, castValue);
        }).toList(),
        errors: _errorStack,
      );

  FilterBuilder _complexSpecificModifierFilter({
    required String column,
    required Object? value,
    required FilterModifier modifier,
    required bool Function(dynamic baseValue, dynamic castValue) baseFunc,
    bool Function(List baseList, List castList)? listFunc,
    bool Function(Map baseMap, Map castMap)? mapFunc,
    bool Function(RangeType baseRange, RangeType castRange)? rangeFunc,
  }) =>
      FilterBuilder(
        _data.where((element) {
          final castResult = _typeCaster.cast(
            element[column],
            value,
            baseAsArrayCaster: true,
          );

          final baseValue = castResult.baseValue;
          final castValue = castResult.castValue;

          if (baseValue is List) {
            return _setError(_errors.notScalarValueError(baseValue));
          }

          if (castValue is! List) {
            return _setError(_errors.malformedLiteralError(value, 'array'));
          }

          if (!castResult.wasSucessful) {
            return _setError(
              _errors.invalidInputSyntaxError(baseValue, castValue, false),
            );
          }

          if (modifier == FilterModifier.any) {
            return castValue.any(
              (element) => _callSpecificModifierFunc(
                baseValue,
                element,
                listFunc,
                mapFunc,
                rangeFunc,
                baseFunc,
              ),
            );
          } else if (modifier == FilterModifier.all) {
            return castValue.every(
              (element) => _callSpecificModifierFunc(
                baseValue,
                element,
                listFunc,
                mapFunc,
                rangeFunc,
                baseFunc,
              ),
            );
          } else {
            throw Exception('Unknown modifier');
          }
        }).toList(),
        errors: _errorStack,
      );

  FilterBuilder _patternMatchingFilter({
    required String column,
    required Object pattern,
    required bool caseSensitive,
    FilterModifier? modifier,
  }) =>
      FilterBuilder(
        _data.where((element) {
          final baseValue = element[column];

          if (baseValue is! String) {
            return _setError(
              _errors.operatorDoesNotExistError(baseValue, '~~'),
            );
          }

          if (modifier != null) {
            final parsedPattern = pattern is String
                ? _syntaxParser.parseValue(pattern.toString())
                : pattern;
            if (parsedPattern is! List) {
              return _setError(
                _errors.malformedLiteralError(parsedPattern, 'array'),
              );
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

  bool _callSpecificModifierFunc(
    dynamic baseValue,
    dynamic castElement,
    bool Function(List baseList, List castList)? listFunc,
    bool Function(Map baseMap, Map castMap)? mapFunc,
    bool Function(RangeType baseRange, RangeType castRange)? rangeFunc,
    bool Function(dynamic baseValue, dynamic castValue) baseFunc,
  ) {
    if (castElement is Map && mapFunc != null) {
      return mapFunc(baseValue, castElement);
    } else if (castElement is List && listFunc != null) {
      return listFunc(baseValue, castElement);
    } else if (castElement is RangeType && rangeFunc != null) {
      return rangeFunc(baseValue, castElement);
    } else {
      return baseFunc(baseValue, castElement);
    }
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
      return value1.entries.every(
        (element) =>
            value2.containsKey(element.key) &&
            value2.containsValue(element.value),
      );
    }
    return value2.entries.every(
      (element) =>
          value1.containsKey(element.key) &&
          value1.containsValue(element.value),
    );
  }

  bool _setError(FilterError error) {
    _errorStack.add(error);
    return true;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code &&
          details == other.details &&
          hint == other.hint;

  @override
  int get hashCode => Object.hashAll([message, code, details, hint]);
}
