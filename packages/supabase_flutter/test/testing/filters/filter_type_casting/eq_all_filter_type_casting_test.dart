// ignore_for_file: dead_code

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/filters/filter_builder.dart';
import 'package:supabase_flutter/src/testing/filters/filter_errors.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';

void main() {
  // Set this to 'true' if you want to print errors logs.
  // If no error occurs then 'null' will be printed.
  const bool logFilterErrors = true;

  late final bool Function({
    required FilterErrorTypes? errorType,
    required dynamic baseValue,
    required dynamic castValue,
    required dynamic additionalArg,
  }) checkValidity;

  setUpAll(() {
    checkValidity = ({
      required errorType,
      required baseValue,
      required castValue,
      required additionalArg,
    }) {
      final result = FilterBuilder([
        {'value': baseValue}
      ]).eqAll('value', castValue).execute();

      if (logFilterErrors) {
        print(result.error.toString());
      }

      final error = result.error;
      final expectedError = errorType != null
          ? FilterBuilderErrors().executeDynamically(
              error: errorType,
              baseValue: baseValue,
              castValue: castValue,
              additionalArg: additionalArg,
            )
          : null;

      final errorEquality = error == expectedError;
      final funcResult = result.isValid && (error == expectedError);

      return errorEquality == false ? !funcResult : funcResult;
    };
  });

  group('int base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: 1,
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{1, 2, 3, 4}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return true when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), true);
    });

    test('should return true when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), true);
    });

    test('should return false when filtering with float list', () {
      expect(
        filter(
          [1.5, 2.5, 3.5, 4.5],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres float list', () {
      expect(
        filter(
          '{1.5, 2.5, 3.5, 4.5}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return true when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), true);
    });

    test('should return true when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), true);
    });

    test('should return false when filtering with bool list', () {
      expect(
        filter(
          [true, false, true, false],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres bool list', () {
      expect(
        filter(
          '{true, false, true, false}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter(
          [DateTime(2022, 1, 1), DateTime(2022, 12, 31), DateTime(2023, 1, 1)],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(
        filter(
          ['2022-01-01', '2022-12-31', '2023-01-01'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(
        filter(
          '{"2022-01-01", "2022-12-31", "2023-01-01"}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with range string list', () {
      expect(
        filter(
          ['[10,20]', '[30,40]', '[200,400]'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres range list', () {
      expect(
        filter(
          '{"[10,20]", "[30,40]", "[200,400]"}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
            RangeType.createRange(range: '[200,400]'),
          ],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter(
          [
            {'value': 10},
            {'value': 20},
            {'value': 30},
          ],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(
          ['{"value": 10}', '{"value": 20}', '{"value": 30}'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter(
          '{{"value": 10}, {"value": 20}, {"value": 30}}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });
  });

  group('float base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: 1.5,
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return true when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), true);
    });

    test('should return true when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), true);
    });

    test('should return true when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), true);
    });

    test('should return true when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), true);
    });

    test('should return true when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), true);
    });

    test('should return true when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), true);
    });

    test('should return false when filtering with bool list', () {
      expect(
        filter(
          [true, false, true, false],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres bool list', () {
      expect(
        filter(
          '{true, false, true, false}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter(
          [DateTime(2022, 1, 1), DateTime(2022, 12, 31), DateTime(2023, 1, 1)],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(
        filter(
          ['2022-01-01', '2022-12-31', '2023-01-01'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(
        filter(
          '{"2022-01-01", "2022-12-31", "2023-01-01"}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with range string list', () {
      expect(
        filter(
          ['[10,20]', '[30,40]', '[200,400]'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres range list', () {
      expect(
        filter(
          '{"[10,20]", "[30,40]", "[200,400]"}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
            RangeType.createRange(range: '[200,400]'),
          ],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter(
          [
            {'value': 10},
            {'value': 20},
            {'value': 30},
          ],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(
          ['{"value": 10}', '{"value": 20}', '{"value": 30}'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter(
          '{{"value": 10}, {"value": 20}, {"value": 30}}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });
  });

  group('string base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: 'sample string',
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{"sample", "string"}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return true when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), true);
    });

    test('should return true when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), true);
    });

    test('should return true when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), true);
    });

    test('should return true when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), true);
    });

    test('should return true when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), true);
    });

    test('should return true when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), true);
    });

    test('should return true when filtering with bool list', () {
      expect(filter([true, false, true, false]), true);
    });

    test('should return true when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), true);
    });

    test('should return true when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        true,
      );
    });

    test('should return true when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), true);
    });

    test('should return true when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), true);
    });

    test('should return true when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), true);
    });

    test('should return true when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), true);
    });

    test('should return true when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        true,
      );
    });

    test('should return true when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        true,
      );
    });

    test('should return true when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        true,
      );
    });

    test('should return true when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        true,
      );
    });
  });

  group('bool base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: true,
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{false, true, false}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with int list', () {
      expect(
        filter(
          [1, 2, 3, 4],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres int list', () {
      expect(
        filter(
          '{1, 2, 3, 4}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with float list', () {
      expect(
        filter(
          [1.5, 2.5, 3.5, 4.5],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres float list', () {
      expect(
        filter(
          '{1.5, 2.5, 3.5, 4.5}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with string list', () {
      expect(
        filter(
          ['1', '2', '3', '4'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres string list', () {
      expect(
        filter(
          '{"1", "2", "3", "4"}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return true when filtering with bool list', () {
      expect(filter([true, false, true, false]), true);
    });

    test('should return true when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), true);
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter(
          [DateTime(2022, 1, 1), DateTime(2022, 12, 31), DateTime(2023, 1, 1)],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(
        filter(
          ['2022-01-01', '2022-12-31', '2023-01-01'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(
        filter(
          '{"2022-01-01", "2022-12-31", "2023-01-01"}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with range string list', () {
      expect(
        filter(
          ['[10,20]', '[30,40]', '[200,400]'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres range list', () {
      expect(
        filter(
          '{"[10,20]", "[30,40]", "[200,400]"}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
            RangeType.createRange(range: '[200,400]'),
          ],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter(
          [
            {'value': 10},
            {'value': 20},
            {'value': 30},
          ],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(
          ['{"value": 10}', '{"value": 20}', '{"value": 30}'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter(
          '{{"value": 10}, {"value": 20}, {"value": 30}}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });
  });

  group('datetime base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: DateTime(2022, 1, 1),
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{2022-01-01, 2022-12-31, 2023-01-01}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with int list', () {
      expect(
        filter(
          [1, 2, 3, 4],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres int list', () {
      expect(
        filter(
          '{1, 2, 3, 4}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with float list', () {
      expect(
        filter(
          [1.5, 2.5, 3.5, 4.5],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres float list', () {
      expect(
        filter(
          '{1.5, 2.5, 3.5, 4.5}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with string list', () {
      expect(
        filter(
          ['1', '2', '3', '4'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres string list', () {
      expect(
        filter(
          '{"1", "2", "3", "4"}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with bool list', () {
      expect(
        filter(
          [true, false, true, false],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres bool list', () {
      expect(
        filter(
          '{true, false, true, false}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return true when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        true,
      );
    });

    test('should return true when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), true);
    });

    test('should return true when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), true);
    });

    test('should return false when filtering with range string list', () {
      expect(
        filter(
          ['[10,20]', '[30,40]', '[200,400]'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres range list', () {
      expect(
        filter(
          '{"[10,20]", "[30,40]", "[200,400]"}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
            RangeType.createRange(range: '[200,400]'),
          ],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter(
          [
            {'value': 10},
            {'value': 20},
            {'value': 30},
          ],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(
          ['{"value": 10}', '{"value": 20}', '{"value": 30}'],
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter(
          '{{"value": 10}, {"value": 20}, {"value": 30}}',
          type: FilterErrorTypes.invalidInputSyntax,
          additionalArg: true,
        ),
        false,
      );
    });
  });

  group('range base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: RangeType.createRange(range: '[10,20]'),
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{[10,20], [30,40], [200,400]}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with int list', () {
      expect(
        filter(
          [1, 2, 3, 4],
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return false when filtering with postgres int list', () {
      expect(
        filter(
          '{1, 2, 3, 4}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return false when filtering with float list', () {
      expect(
        filter(
          [1.5, 2.5, 3.5, 4.5],
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return false when filtering with postgres float list', () {
      expect(
        filter(
          '{1.5, 2.5, 3.5, 4.5}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return false when filtering with string list', () {
      expect(
        filter(
          ['1', '2', '3', '4'],
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return false when filtering with postgres string list', () {
      expect(
        filter(
          '{"1", "2", "3", "4"}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return false when filtering with bool list', () {
      expect(
        filter(
          [true, false, true, false],
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return false when filtering with postgres bool list', () {
      expect(
        filter(
          '{true, false, true, false}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter(
          [DateTime(2022, 1, 1), DateTime(2022, 12, 31), DateTime(2023, 1, 1)],
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(
        filter(
          ['2022-01-01', '2022-12-31', '2023-01-01'],
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(
        filter(
          '{"2022-01-01", "2022-12-31", "2023-01-01"}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return true when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), true);
    });

    test('should return true when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), true);
    });

    test('should return true when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        true,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter(
          [
            {'value': 10},
            {'value': 20},
            {'value': 30},
          ],
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(
          ['{"value": 10}', '{"value": 20}', '{"value": 30}'],
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter(
          '{{"value": 10}, {"value": 20}, {"value": 30}}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'range',
        ),
        false,
      );
    });
  });

  group('json base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: {'age': 10},
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{{"age": 10}, {"age": 20}, {"age": 30}}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'age': 10},
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"age": 10}',
          type: FilterErrorTypes.malformedLiteral,
          additionalArg: 'array',
        ),
        false,
      );
    });

    test('should return true when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), true);
    });

    test('should return true when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), true);
    });

    test('should return true when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), true);
    });

    test('should return true when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), true);
    });

    test('should return true when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), true);
    });

    test('should return true when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), true);
    });

    test('should return true when filtering with bool list', () {
      expect(filter([true, false, true, false]), true);
    });

    test('should return true when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), true);
    });

    test('should return true when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        true,
      );
    });

    test('should return true when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), true);
    });

    test('should return true when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), true);
    });

    test('should return true when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), true);
    });

    test('should return true when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), true);
    });

    test('should return true when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        true,
      );
    });

    test('should return true when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        true,
      );
    });

    test('should return true when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        true,
      );
    });

    test('should return true when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        true,
      );
    });
  });

  group('int list base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: [1, 2, 3, 4],
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with valid string', () {
      expect(
        filter(
          '{1, 2, 3, 4}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with int list', () {
      expect(
        filter(
          [1, 2, 3, 4],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres int list', () {
      expect(
        filter(
          '{1, 2, 3, 4}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float list', () {
      expect(
        filter(
          [1.5, 2.5, 3.5, 4.5],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres float list', () {
      expect(
        filter(
          '{1.5, 2.5, 3.5, 4.5}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with string list', () {
      expect(
        filter(
          ['1', '2', '3', '4'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres string list', () {
      expect(
        filter(
          '{"1", "2", "3", "4"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool list', () {
      expect(
        filter(
          [true, false, true, false],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres bool list', () {
      expect(
        filter(
          '{true, false, true, false}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter(
          [DateTime(2022, 1, 1), DateTime(2022, 12, 31), DateTime(2023, 1, 1)],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(
        filter(
          ['2022-01-01', '2022-12-31', '2023-01-01'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(
        filter(
          '{"2022-01-01", "2022-12-31", "2023-01-01"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string list', () {
      expect(
        filter(
          ['[10,20]', '[30,40]', '[200,400]'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres range list', () {
      expect(
        filter(
          '{"[10,20]", "[30,40]", "[200,400]"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
            RangeType.createRange(range: '[200,400]'),
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter(
          [
            {'value': 10},
            {'value': 20},
            {'value': 30},
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(
          ['{"value": 10}', '{"value": 20}', '{"value": 30}'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter(
          '{{"value": 10}, {"value": 20}, {"value": 30}}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });
  });

  group('float list base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: [1.5, 2.5, 3.5, 4.5],
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with valid string', () {
      expect(
        filter(
          '{1.5, 2.5, 3.5, 4.5}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with int list', () {
      expect(
        filter(
          [1, 2, 3, 4],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres int list', () {
      expect(
        filter(
          '{1, 2, 3, 4}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float list', () {
      expect(
        filter(
          [1.5, 2.5, 3.5, 4.5],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres float list', () {
      expect(
        filter(
          '{1.5, 2.5, 3.5, 4.5}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with string list', () {
      expect(
        filter(
          ['1', '2', '3', '4'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres string list', () {
      expect(
        filter(
          '{"1", "2", "3", "4"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool list', () {
      expect(
        filter(
          [true, false, true, false],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres bool list', () {
      expect(
        filter(
          '{true, false, true, false}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter(
          [DateTime(2022, 1, 1), DateTime(2022, 12, 31), DateTime(2023, 1, 1)],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(
        filter(
          ['2022-01-01', '2022-12-31', '2023-01-01'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(
        filter(
          '{"2022-01-01", "2022-12-31", "2023-01-01"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string list', () {
      expect(
        filter(
          ['[10,20]', '[30,40]', '[200,400]'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres range list', () {
      expect(
        filter(
          '{"[10,20]", "[30,40]", "[200,400]"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
            RangeType.createRange(range: '[200,400]'),
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter(
          [
            {'value': 10},
            {'value': 20},
            {'value': 30},
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(
          ['{"value": 10}', '{"value": 20}', '{"value": 30}'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter(
          '{{"value": 10}, {"value": 20}, {"value": 30}}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });
  });

  group('string list base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: [
              'sample',
              'string',
              'to',
              'demonstrate',
              'an',
              'array',
            ],
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with valid string', () {
      expect(
        filter(
          '{"sample", "string"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with int list', () {
      expect(
        filter(
          [1, 2, 3, 4],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres int list', () {
      expect(
        filter(
          '{1, 2, 3, 4}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float list', () {
      expect(
        filter(
          [1.5, 2.5, 3.5, 4.5],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres float list', () {
      expect(
        filter(
          '{1.5, 2.5, 3.5, 4.5}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with string list', () {
      expect(
        filter(
          ['1', '2', '3', '4'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres string list', () {
      expect(
        filter(
          '{"1", "2", "3", "4"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool list', () {
      expect(
        filter(
          [true, false, true, false],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres bool list', () {
      expect(
        filter(
          '{true, false, true, false}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter(
          [DateTime(2022, 1, 1), DateTime(2022, 12, 31), DateTime(2023, 1, 1)],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(
        filter(
          ['2022-01-01', '2022-12-31', '2023-01-01'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(
        filter(
          '{"2022-01-01", "2022-12-31", "2023-01-01"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string list', () {
      expect(
        filter(
          ['[10,20]', '[30,40]', '[200,400]'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres range list', () {
      expect(
        filter(
          '{"[10,20]", "[30,40]", "[200,400]"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
            RangeType.createRange(range: '[200,400]'),
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter(
          [
            {'value': 10},
            {'value': 20},
            {'value': 30},
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(
          ['{"value": 10}', '{"value": 20}', '{"value": 30}'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter(
          '{{"value": 10}, {"value": 20}, {"value": 30}}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });
  });

  group('bool list base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: [true, false, true],
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with valid string', () {
      expect(
        filter(
          '{true, false}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with int list', () {
      expect(
        filter(
          [1, 2, 3, 4],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres int list', () {
      expect(
        filter(
          '{1, 2, 3, 4}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float list', () {
      expect(
        filter(
          [1.5, 2.5, 3.5, 4.5],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres float list', () {
      expect(
        filter(
          '{1.5, 2.5, 3.5, 4.5}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with string list', () {
      expect(
        filter(
          ['1', '2', '3', '4'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres string list', () {
      expect(
        filter(
          '{"1", "2", "3", "4"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool list', () {
      expect(
        filter(
          [true, false, true, false],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres bool list', () {
      expect(
        filter(
          '{true, false, true, false}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter(
          [DateTime(2022, 1, 1), DateTime(2022, 12, 31), DateTime(2023, 1, 1)],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(
        filter(
          ['2022-01-01', '2022-12-31', '2023-01-01'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(
        filter(
          '{"2022-01-01", "2022-12-31", "2023-01-01"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string list', () {
      expect(
        filter(
          ['[10,20]', '[30,40]', '[200,400]'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres range list', () {
      expect(
        filter(
          '{"[10,20]", "[30,40]", "[200,400]"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
            RangeType.createRange(range: '[200,400]'),
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter(
          [
            {'value': 10},
            {'value': 20},
            {'value': 30},
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(
          ['{"value": 10}', '{"value": 20}', '{"value": 30}'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter(
          '{{"value": 10}, {"value": 20}, {"value": 30}}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });
  });

  group('datetime list base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: [
              DateTime(2022, 1, 1),
              DateTime(2022, 12, 31),
              DateTime(2023, 1, 1),
            ],
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with valid string', () {
      expect(
        filter(
          '{2022-01-01, 2022-12-31}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with int list', () {
      expect(
        filter(
          [1, 2, 3, 4],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres int list', () {
      expect(
        filter(
          '{1, 2, 3, 4}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float list', () {
      expect(
        filter(
          [1.5, 2.5, 3.5, 4.5],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres float list', () {
      expect(
        filter(
          '{1.5, 2.5, 3.5, 4.5}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with string list', () {
      expect(
        filter(
          ['1', '2', '3', '4'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres string list', () {
      expect(
        filter(
          '{"1", "2", "3", "4"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool list', () {
      expect(
        filter(
          [true, false, true, false],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres bool list', () {
      expect(
        filter(
          '{true, false, true, false}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter(
          [DateTime(2022, 1, 1), DateTime(2022, 12, 31), DateTime(2023, 1, 1)],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(
        filter(
          ['2022-01-01', '2022-12-31', '2023-01-01'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(
        filter(
          '{"2022-01-01", "2022-12-31", "2023-01-01"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string list', () {
      expect(
        filter(
          ['[10,20]', '[30,40]', '[200,400]'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres range list', () {
      expect(
        filter(
          '{"[10,20]", "[30,40]", "[200,400]"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
            RangeType.createRange(range: '[200,400]'),
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter(
          [
            {'value': 10},
            {'value': 20},
            {'value': 30},
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(
          ['{"value": 10}', '{"value": 20}', '{"value": 30}'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter(
          '{{"value": 10}, {"value": 20}, {"value": 30}}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });
  });

  group('range list base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: [
              RangeType.createRange(range: '[10,20]'),
              RangeType.createRange(range: '[30,40]'),
              RangeType.createRange(range: '[200,400]'),
            ],
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with valid string', () {
      expect(
        filter(
          '{[10,20], [30,40], [200,400]}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with int list', () {
      expect(
        filter(
          [1, 2, 3, 4],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres int list', () {
      expect(
        filter(
          '{1, 2, 3, 4}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float list', () {
      expect(
        filter(
          [1.5, 2.5, 3.5, 4.5],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres float list', () {
      expect(
        filter(
          '{1.5, 2.5, 3.5, 4.5}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with string list', () {
      expect(
        filter(
          ['1', '2', '3', '4'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres string list', () {
      expect(
        filter(
          '{"1", "2", "3", "4"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool list', () {
      expect(
        filter(
          [true, false, true, false],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres bool list', () {
      expect(
        filter(
          '{true, false, true, false}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter(
          [DateTime(2022, 1, 1), DateTime(2022, 12, 31), DateTime(2023, 1, 1)],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(
        filter(
          ['2022-01-01', '2022-12-31', '2023-01-01'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(
        filter(
          '{"2022-01-01", "2022-12-31", "2023-01-01"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string list', () {
      expect(
        filter(
          ['[10,20]', '[30,40]', '[200,400]'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres range list', () {
      expect(
        filter(
          '{"[10,20]", "[30,40]", "[200,400]"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
            RangeType.createRange(range: '[200,400]'),
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter(
          [
            {'value': 10},
            {'value': 20},
            {'value': 30},
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(
          ['{"value": 10}', '{"value": 20}', '{"value": 30}'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter(
          '{{"value": 10}, {"value": 20}, {"value": 30}}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });
  });

  group('json list base type', () {
    late final bool Function(
      dynamic filterValue, {
      FilterErrorTypes? type,
      dynamic additionalArg,
    }) filter;

    setUpAll(() {
      filter = (filterValue, {type, additionalArg}) => checkValidity(
            errorType: type,
            baseValue: [
              {'age': 10},
              {'age': 20},
              {'age': 30}
            ],
            castValue: filterValue,
            additionalArg: additionalArg,
          );
    });

    test('should return false when filtering with int', () {
      expect(
        filter(
          22,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float', () {
      expect(
        filter(
          22.5,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with valid string', () {
      expect(
        filter(
          '{{"age": 10}, {"age": 20}, {"age": 30}}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with invalid string', () {
      expect(
        filter(
          'invalid',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool', () {
      expect(
        filter(
          true,
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal', () {
      expect(
        filter(
          DateTime(2022, 1, 1),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string', () {
      expect(
        filter(
          '2022-01-01',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string', () {
      expect(
        filter(
          '[10,20]',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal', () {
      expect(
        filter(
          RangeType.createRange(range: '[10,20]'),
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal', () {
      expect(
        filter(
          {'value': 10},
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string', () {
      expect(
        filter(
          '{"value": 10}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with int list', () {
      expect(
        filter(
          [1, 2, 3, 4],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres int list', () {
      expect(
        filter(
          '{1, 2, 3, 4}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with float list', () {
      expect(
        filter(
          [1.5, 2.5, 3.5, 4.5],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres float list', () {
      expect(
        filter(
          '{1.5, 2.5, 3.5, 4.5}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with string list', () {
      expect(
        filter(
          ['1', '2', '3', '4'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres string list', () {
      expect(
        filter(
          '{"1", "2", "3", "4"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with bool list', () {
      expect(
        filter(
          [true, false, true, false],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres bool list', () {
      expect(
        filter(
          '{true, false, true, false}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter(
          [DateTime(2022, 1, 1), DateTime(2022, 12, 31), DateTime(2023, 1, 1)],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(
        filter(
          ['2022-01-01', '2022-12-31', '2023-01-01'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(
        filter(
          '{"2022-01-01", "2022-12-31", "2023-01-01"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range string list', () {
      expect(
        filter(
          ['[10,20]', '[30,40]', '[200,400]'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres range list', () {
      expect(
        filter(
          '{"[10,20]", "[30,40]", "[200,400]"}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
            RangeType.createRange(range: '[200,400]'),
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter(
          [
            {'value': 10},
            {'value': 20},
            {'value': 30},
          ],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(
          ['{"value": 10}', '{"value": 20}', '{"value": 30}'],
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter(
          '{{"value": 10}, {"value": 20}, {"value": 30}}',
          type: FilterErrorTypes.notScalarValue,
        ),
        false,
      );
    });
  });
}
