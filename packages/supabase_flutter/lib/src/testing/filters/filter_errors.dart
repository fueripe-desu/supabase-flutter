import 'package:supabase_flutter/src/testing/filters/filter_builder.dart';
import 'package:supabase_flutter/src/testing/postgrest/supabase_test_postgrest.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';

enum FilterErrorTypes {
  malformedArrayLiteral,
  notScalarValue,
  operatorDoesNotExist,
  invalidArgument,
  failedToParserIsFilter,
  invalidInputSyntax,
  datetimeOutOfRange,
}

class FilterBuilderErrors {
  final PostrestSyntaxParser _parser = PostrestSyntaxParser([]);

  FilterError malformedLiteralError(dynamic castValue, String literalName) {
    final parsedCastValue =
        castValue is String ? _parser.parseValue(castValue) : castValue;

    late final String castValueString;

    if (literalName == 'range' &&
        parsedCastValue is List &&
        parsedCastValue.isNotEmpty) {
      final parsedElements = parsedCastValue.map((e) {
        if (e is String) {
          return _parser.parseValue(e).toString();
        } else {
          return e.toString();
        }
      }).toList();

      castValueString = parsedElements.first;
    } else {
      castValueString = parsedCastValue is List
          ? _handleList(parsedCastValue)
          : parsedCastValue.toString();
    }

    late final String details;

    switch (literalName) {
      case 'array':
        details = 'Array value must start with "{" or dimension information.';
        break;
      case 'range':
        details = 'Missing left parenthesis or bracket.';
        break;
      default:
        details = 'Bad Request';
    }

    return FilterError(
      message: 'malformed $literalName literal: "$castValueString"',
      code: '22P02',
      details: details,
      hint: null,
    );
  }

  // Only thrown when the base value is list
  FilterError notScalarValueError(List<dynamic>? baseValue) => FilterError(
        message:
            'could not find array type for data type ${_getTypeString(baseValue)}[]',
        code: '42704',
        details: 'Bad Request',
        hint: null,
      );

  FilterError operatorDoesNotExistError(
    dynamic baseValue,
    String operatorString,
  ) =>
      FilterError(
        message:
            'operator does not exist: ${_getTypeString(baseValue)}${baseValue is List ? '[]' : ''} $operatorString unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

  FilterError invalidArgumentError(dynamic baseValue, String keywordString) =>
      FilterError(
        message:
            'argument of $keywordString must be type boolean, not type ${_getTypeString(baseValue)}${baseValue is List ? '[]' : ''}',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

  FilterError failedToParseIsFilterError(dynamic castValue) => FilterError(
        message:
            '"failed to parse filter (is.${castValue.toString()})" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "${castValue.toString()[0]}" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

  FilterError invalidInputSyntaxError(
    dynamic baseValue,
    dynamic castValue,
    bool grabOnlyFirstElement,
  ) {
    final dynamic processedCast =
        castValue is String ? _parser.parseValue(castValue) : castValue;
    late final String valueString;

    if (processedCast is List) {
      final parsedElements = processedCast.map((e) {
        if (e is String) {
          return _parser.parseValue(e).toString();
        } else {
          return e.toString();
        }
      }).toList();
      if (parsedElements.isNotEmpty && grabOnlyFirstElement == true) {
        valueString = parsedElements.first.toString();
      } else {
        valueString = _toPostgresList(parsedElements);
      }
    } else {
      valueString = processedCast.toString();
    }

    return FilterError(
      message:
          'invalid input syntax for type ${_getTypeString(baseValue)}${baseValue is List ? '[]' : ''}: "$valueString"',
      code: '22P02',
      details: 'Bad Request',
      hint: null,
    );
  }

  FilterError datetimeOutOfRange(dynamic castValue) => FilterError(
        message:
            'date/time field value out of range: "${castValue is List ? _handleList(castValue) : castValue.toString()}"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

  // This function is used mainly to facilitate tests, but it
  // also can be used internally to be able to execute errors
  // with less boiler plate but a higher runtime error chance.
  FilterError executeDynamically({
    required FilterErrorTypes error,
    required dynamic baseValue,
    required dynamic castValue,
    required dynamic additionalArg,
  }) {
    switch (error) {
      case FilterErrorTypes.malformedArrayLiteral:
        return malformedLiteralError(castValue, additionalArg);
      case FilterErrorTypes.notScalarValue:
        return notScalarValueError(baseValue);
      case FilterErrorTypes.operatorDoesNotExist:
        return operatorDoesNotExistError(baseValue, additionalArg);
      case FilterErrorTypes.invalidArgument:
        return invalidArgumentError(baseValue, additionalArg);
      case FilterErrorTypes.failedToParserIsFilter:
        return failedToParseIsFilterError(castValue);
      case FilterErrorTypes.invalidInputSyntax:
        return invalidInputSyntaxError(
          baseValue,
          castValue,
          additionalArg ?? false,
        );
      case FilterErrorTypes.datetimeOutOfRange:
        return datetimeOutOfRange(castValue);
    }
  }

  String _handleList(List list) {
    if (_getListFirstElement(list) is String) {
      return _toPostgresList(_addQuotesToAllStringElements(list));
    } else {
      return _toPostgresList(list);
    }
  }

  String _toPostgresList(List list) {
    final listString = list.map((e) {
      final parsed = _parser.parseValue(e.toString());
      final addQuotes = parsed is String && !_isRange(parsed);
      return addQuotes ? '"$parsed"' : parsed.toString();
    }).toList();
    final elements = listString.join(", ");
    return '{$elements}';
  }

  bool _isRange(String range) {
    try {
      RangeType.createRange(range: range);
      return true;
    } catch (err) {
      return false;
    }
  }

  List<String> _addQuotesToAllStringElements(List list) =>
      list.map((e) => '"${e as String}"').toList();

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
}
