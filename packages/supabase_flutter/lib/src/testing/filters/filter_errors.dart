import 'package:supabase_flutter/src/testing/filters/filter_builder.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';

class FilterBuilderErrors {
  // args[0] -> castType
  // args[1] -> literalName
  FilterError malformedLiteralError(List<dynamic> args) => FilterError(
        message: 'malformed ${args[1]} literal: "${args[0].toString()}"',
        code: '22P02',
        details: args[1] == 'array'
            ? 'Array value must start with "{" or dimension information.'
            : 'Missing left parenthesis or bracket.',
        hint: null,
      );

  // args[0] -> baseType
  FilterError notScalarValueError(List<dynamic> args) => FilterError(
        message:
            'could not find array type for data type ${_getTypeString(args[0])}[]',
        code: '42704',
        details: 'Bad Request',
        hint: null,
      );

  // args[0] -> baseType
  // args[1] -> operatorStr
  FilterError operatorDoesNotExistError(List<dynamic> args) => FilterError(
        message:
            'operator does not exist: ${_getTypeString(args[0])}${args[0] is List ? '[]' : ''} ${args[1]} unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

  // args[0] -> baseType
  // args[1] -> keywordString
  FilterError invalidArgumentError(List<dynamic> args) => FilterError(
        message:
            'argument of ${args[1]} must be type boolean, not type ${_getTypeString(args[0])}',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

  // args[0] -> castValue
  FilterError failedToParseIsFilterError(List<dynamic> args) => FilterError(
        message:
            '"failed to parse filter (is.${args[0].toString()})" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "${args[0].toString()[0]}" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

  // args[0] -> baseType
  // args[1] -> castType
  // args[2] -> grabOnlyFirstElement
  FilterError invalidInputSyntaxError(List<dynamic> args) {
    late final String valueString;

    if (args[1] is List) {
      if (args[1].isNotEmpty && args[2] == true) {
        valueString = args[1].first.toString();
      } else {
        valueString = _toPostgresList(args[1].toString());
      }
    } else {
      valueString = args[1].toString();
    }

    return FilterError(
      message:
          'invalid input syntax for type ${_getTypeString(args[0])}: "$valueString"',
      code: '22P02',
      details: 'Bad Request',
      hint: null,
    );
  }

  // args[0] -> castType
  FilterError datetimeOutOfRange(List<dynamic> args) => FilterError(
        message: 'date/time field value out of range: "${args[0]}"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

  String _toPostgresList(String listString) {
    final elements = listString.substring(
      listString.firstIndex! + 1,
      listString.lastIndex,
    );
    return '{$elements}';
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
}
