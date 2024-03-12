import 'package:supabase_flutter/src/testing/filters/filter_builder.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';

class FilterBuilderErrors {
  FilterError malformedLiteralError(dynamic castValue, String literalName) {
    final castValueString =
        castValue is List ? _handleList(castValue) : castValue.toString();

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

  FilterError notScalarValueError(dynamic baseValue) => FilterError(
        message:
            'could not find array type for data type ${_getTypeString(baseValue.toString())}[]',
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
            'operator does not exist: ${_getTypeString(baseValue.toString())}${baseValue is List ? '[]' : ''} $operatorString unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

  FilterError invalidArgumentError(dynamic baseValue, String keywordString) =>
      FilterError(
        message:
            'argument of $keywordString must be type boolean, not type ${_getTypeString(baseValue.toString())}',
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
    late final String valueString;

    if (castValue is List) {
      if (castValue.isNotEmpty && grabOnlyFirstElement == true) {
        valueString = castValue.first.toString();
      } else {
        valueString = _toPostgresList(castValue.toString());
      }
    } else {
      valueString = castValue.toString();
    }

    return FilterError(
      message:
          'invalid input syntax for type ${_getTypeString(baseValue.toString())}: "$valueString"',
      code: '22P02',
      details: 'Bad Request',
      hint: null,
    );
  }

  FilterError datetimeOutOfRange(dynamic castType) => FilterError(
        message: 'date/time field value out of range: "$castType"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

  String _handleList(List list) {
    if (_getListFirstElement(list) is String) {
      return _toPostgresList(_addQuotesToAllStringElements(list).toString());
    } else {
      return _toPostgresList(list.toString());
    }
  }

  String _toPostgresList(String listString) {
    final elements = listString.substring(
      listString.firstIndex! + 1,
      listString.lastIndex,
    );
    return '{$elements}';
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
