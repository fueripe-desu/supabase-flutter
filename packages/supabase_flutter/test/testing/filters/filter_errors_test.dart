import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/filters/filter_builder.dart';
import 'package:supabase_flutter/src/testing/filters/filter_errors.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';

void main() {
  late final FilterBuilderErrors errorBuilder;

  setUpAll(() {
    errorBuilder = FilterBuilderErrors();
  });

  group('malformed literal error', () {
    late final FilterError Function(dynamic castValue, String literalName)
        error;

    setUpAll(() {
      error = (castValue, literalName) =>
          errorBuilder.malformedLiteralError(castValue, literalName);
    });

    test('should return the correct error when \'literalName\' is \'array\'',
        () {
      const expected = FilterError(
        message: 'malformed array literal: "22"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error(22, 'array'), expected);
    });

    test('should return the correct error when \'literalName\' is \'range\'',
        () {
      const expected = FilterError(
        message: 'malformed range literal: "22"',
        code: '22P02',
        details: 'Missing left parenthesis or bracket.',
        hint: null,
      );

      expect(error(22, 'range'), expected);
    });

    test(
        'should return the correct error when \'literalName\' is an unexpected value',
        () {
      const expected = FilterError(
        message: 'malformed float literal: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(22, 'float'), expected);
    });

    test('should return the correct error when \'castValue\' is int', () {
      const expected = FilterError(
        message: 'malformed array literal: "22"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error(22, 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is double', () {
      const expected = FilterError(
        message: 'malformed array literal: "22.5"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error(22.5, 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is string', () {
      const expected = FilterError(
        message: 'malformed array literal: "string sample"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error('string sample', 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is bool', () {
      const expected = FilterError(
        message: 'malformed array literal: "true"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error(true, 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is datetime', () {
      const expected = FilterError(
        message: 'malformed array literal: "2022-01-01 00:00:00.000"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error(DateTime(2022, 1, 1), 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is range', () {
      const expected = FilterError(
        message: 'malformed array literal: "[10,20]"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error(RangeType.createRange(range: '[10,20]'), 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is map', () {
      const expected = FilterError(
        message: 'malformed array literal: "{value: 10}"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error({'value': 10}, 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is null', () {
      const expected = FilterError(
        message: 'malformed array literal: "null"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error(null, 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is empty list',
        () {
      const expected = FilterError(
        message: 'malformed array literal: "{}"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error([], 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is null list', () {
      const expected = FilterError(
        message: 'malformed array literal: "{null, null, null}"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error([null, null, null], 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is int list', () {
      const expected = FilterError(
        message: 'malformed array literal: "{1, 2, 3, 4}"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error([1, 2, 3, 4], 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is double list',
        () {
      const expected = FilterError(
        message: 'malformed array literal: "{1.5, 2.5, 3.5, 4.5}"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error([1.5, 2.5, 3.5, 4.5], 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is string list',
        () {
      const expected = FilterError(
        message: 'malformed array literal: "{"1", "2", "3", "4"}"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error(['1', '2', '3', '4'], 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is bool list', () {
      const expected = FilterError(
        message: 'malformed array literal: "{false, true, false, true}"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(error([false, true, false, true], 'array'), expected);
    });

    test('should return the correct error when \'castValue\' is datetime list',
        () {
      const expected = FilterError(
        message:
            'malformed array literal: "{2022-01-01 00:00:00.000, 2022-12-31 00:00:00.000}"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(
        error([DateTime(2022, 1, 1), DateTime(2022, 12, 31)], 'array'),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is range list',
        () {
      const expected = FilterError(
        message: 'malformed array literal: "{[10,20], [30,40]}"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(
        error(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
          ],
          'array',
        ),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is map list', () {
      const expected = FilterError(
        message: 'malformed array literal: "{{value: 10}, {value: 20}}"',
        code: '22P02',
        details: 'Array value must start with "{" or dimension information.',
        hint: null,
      );

      expect(
        error(
          [
            {'value': 10},
            {'value': 20},
          ],
          'array',
        ),
        expected,
      );
    });
  });

  group('not scalar value error', () {
    late final FilterError Function(List<dynamic>? baseValue) error;

    setUpAll(() {
      error = (baseValue) => errorBuilder.notScalarValueError(baseValue);
    });

    test('should return the correct error when \'baseValue\' is null', () {
      const expected = FilterError(
        message: 'could not find array type for data type null or empty list[]',
        code: '42704',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(null), expected);
    });

    test('should return the correct error when \'baseValue\' is empty list',
        () {
      const expected = FilterError(
        message: 'could not find array type for data type null or empty list[]',
        code: '42704',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([]), expected);
    });

    test('should return the correct error when \'baseValue\' is null list', () {
      const expected = FilterError(
        message: 'could not find array type for data type null or empty list[]',
        code: '42704',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([null, null, null]), expected);
    });

    test('should return the correct error when \'baseValue\' is int list', () {
      const expected = FilterError(
        message: 'could not find array type for data type int[]',
        code: '42704',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([1, 2, 3, 4]), expected);
    });

    test('should return the correct error when \'baseValue\' is double list',
        () {
      const expected = FilterError(
        message: 'could not find array type for data type double precision[]',
        code: '42704',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([1.5, 2.5, 3.5, 4.5]), expected);
    });

    test('should return the correct error when \'baseValue\' is string list',
        () {
      const expected = FilterError(
        message: 'could not find array type for data type text[]',
        code: '42704',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(['1', '2', '3', '4']), expected);
    });

    test('should return the correct error when \'baseValue\' is bool list', () {
      const expected = FilterError(
        message: 'could not find array type for data type boolean[]',
        code: '42704',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([false, true, false, true]), expected);
    });

    test('should return the correct error when \'baseValue\' is datetime list',
        () {
      const expected = FilterError(
        message:
            'could not find array type for data type timestamp with time zone[]',
        code: '42704',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
        ]),
        expected,
      );
    });

    test('should return the correct error when \'baseValue\' is range list',
        () {
      const expected = FilterError(
        message: 'could not find array type for data type range[]',
        code: '42704',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
          ],
        ),
        expected,
      );
    });

    test('should return the correct error when \'baseValue\' is map list', () {
      const expected = FilterError(
        message: 'could not find array type for data type jsonb[]',
        code: '42704',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(
          [
            {'value': 10},
            {'value': 20},
          ],
        ),
        expected,
      );
    });
  });

  group('operator does not exist error', () {
    late final FilterError Function(
      dynamic baseValue,
      String operatorString,
    ) error;

    setUpAll(() {
      error = (baseValue, operatorString) =>
          errorBuilder.operatorDoesNotExistError(baseValue, operatorString);
    });

    test('should return the correct error when \'baseValue\' is int', () {
      const expected = FilterError(
        message: 'operator does not exist: int && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error(22, '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is double', () {
      const expected = FilterError(
        message: 'operator does not exist: double precision && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error(22.5, '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is string', () {
      const expected = FilterError(
        message: 'operator does not exist: text && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error('string sample', '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is bool', () {
      const expected = FilterError(
        message: 'operator does not exist: boolean && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error(true, '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is datetime', () {
      const expected = FilterError(
        message: 'operator does not exist: timestamp with time zone && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error(DateTime(2022, 1, 1), '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is range', () {
      const expected = FilterError(
        message: 'operator does not exist: range && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error(RangeType.createRange(range: '[10,20]'), '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is map', () {
      const expected = FilterError(
        message: 'operator does not exist: jsonb && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error({'value': 10}, '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is null', () {
      const expected = FilterError(
        message: 'operator does not exist: null or empty list && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error(null, '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is empty list',
        () {
      const expected = FilterError(
        message: 'operator does not exist: null or empty list[] && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error([], '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is null list', () {
      const expected = FilterError(
        message: 'operator does not exist: null or empty list[] && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error([null, null, null], '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is int list', () {
      const expected = FilterError(
        message: 'operator does not exist: int[] && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error([1, 2, 3, 4], '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is double list',
        () {
      const expected = FilterError(
        message: 'operator does not exist: double precision[] && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error([1.5, 2.5, 3.5, 4.5], '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is string list',
        () {
      const expected = FilterError(
        message: 'operator does not exist: text[] && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error(['1', '2', '3', '4'], '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is bool list', () {
      const expected = FilterError(
        message: 'operator does not exist: boolean[] && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(error([false, true, false, true], '&&'), expected);
    });

    test('should return the correct error when \'baseValue\' is datetime list',
        () {
      const expected = FilterError(
        message:
            'operator does not exist: timestamp with time zone[] && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(
        error(
          [
            DateTime(2022, 1, 1),
            DateTime(2022, 12, 31),
          ],
          '&&',
        ),
        expected,
      );
    });

    test('should return the correct error when \'baseValue\' is range list',
        () {
      const expected = FilterError(
        message: 'operator does not exist: range[] && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(
        error(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
          ],
          '&&',
        ),
        expected,
      );
    });

    test('should return the correct error when \'baseValue\' is map list', () {
      const expected = FilterError(
        message: 'operator does not exist: jsonb[] && unknown',
        code: '42883',
        details: 'Not Found',
        hint:
            'No operator matches the given name and argument types. You might need to add explicit type casts.',
      );

      expect(
        error(
          [
            {'value': 10},
            {'value': 20},
          ],
          '&&',
        ),
        expected,
      );
    });
  });

  group('invalid argument error error', () {
    late final FilterError Function(
      dynamic baseValue,
      String keywordString,
    ) error;

    setUpAll(() {
      error = (baseValue, keywordString) =>
          errorBuilder.invalidArgumentError(baseValue, keywordString);
    });

    test('should return the correct error when \'baseValue\' is int', () {
      const expected = FilterError(
        message: 'argument of WHERE must be type boolean, not type int',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(22, 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is double', () {
      const expected = FilterError(
        message:
            'argument of WHERE must be type boolean, not type double precision',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(22.5, 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is string', () {
      const expected = FilterError(
        message: 'argument of WHERE must be type boolean, not type text',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error('string sample', 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is bool', () {
      const expected = FilterError(
        message: 'argument of WHERE must be type boolean, not type boolean',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(true, 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is datetime', () {
      const expected = FilterError(
        message:
            'argument of WHERE must be type boolean, not type timestamp with time zone',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(DateTime(2022, 1, 1), 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is range', () {
      const expected = FilterError(
        message: 'argument of WHERE must be type boolean, not type range',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(RangeType.createRange(range: '[10,20]'), 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is map', () {
      const expected = FilterError(
        message: 'argument of WHERE must be type boolean, not type jsonb',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error({'value': 10}, 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is null', () {
      const expected = FilterError(
        message:
            'argument of WHERE must be type boolean, not type null or empty list',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(null, 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is empty list',
        () {
      const expected = FilterError(
        message:
            'argument of WHERE must be type boolean, not type null or empty list[]',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([], 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is null list', () {
      const expected = FilterError(
        message:
            'argument of WHERE must be type boolean, not type null or empty list[]',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([null, null, null], 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is int list', () {
      const expected = FilterError(
        message: 'argument of WHERE must be type boolean, not type int[]',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([1, 2, 3, 4], 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is double list',
        () {
      const expected = FilterError(
        message:
            'argument of WHERE must be type boolean, not type double precision[]',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([1.5, 2.5, 3.5, 4.5], 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is string list',
        () {
      const expected = FilterError(
        message: 'argument of WHERE must be type boolean, not type text[]',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(['1', '2', '3', '4'], 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is bool list', () {
      const expected = FilterError(
        message: 'argument of WHERE must be type boolean, not type boolean[]',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([false, true, false, true], 'WHERE'), expected);
    });

    test('should return the correct error when \'baseValue\' is datetime list',
        () {
      const expected = FilterError(
        message:
            'argument of WHERE must be type boolean, not type timestamp with time zone[]',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(
          [
            DateTime(2022, 1, 1),
            DateTime(2022, 12, 31),
          ],
          'WHERE',
        ),
        expected,
      );
    });

    test('should return the correct error when \'baseValue\' is range list',
        () {
      const expected = FilterError(
        message: 'argument of WHERE must be type boolean, not type range[]',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
          ],
          'WHERE',
        ),
        expected,
      );
    });

    test('should return the correct error when \'baseValue\' is map list', () {
      const expected = FilterError(
        message: 'argument of WHERE must be type boolean, not type jsonb[]',
        code: '42804',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(
          [
            {'value': 10},
            {'value': 20},
          ],
          'WHERE',
        ),
        expected,
      );
    });
  });

  group('failed to parse is filter error', () {
    late final FilterError Function(dynamic castValue) error;

    setUpAll(() {
      error = (castValue) => errorBuilder.failedToParseIsFilterError(castValue);
    });

    test('should return the correct error when \'baseValue\' is int', () {
      const expected = FilterError(
        message: '"failed to parse filter (is.22)" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "2" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error(22), expected);
    });

    test('should return the correct error when \'baseValue\' is double', () {
      const expected = FilterError(
        message: '"failed to parse filter (is.22.5)" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "2" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error(22.5), expected);
    });

    test('should return the correct error when \'baseValue\' is string', () {
      const expected = FilterError(
        message:
            '"failed to parse filter (is.string sample)" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "s" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error('string sample'), expected);
    });

    test('should return the correct error when \'baseValue\' is bool', () {
      const expected = FilterError(
        message: '"failed to parse filter (is.true)" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "t" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error(true), expected);
    });

    test('should return the correct error when \'baseValue\' is datetime', () {
      const expected = FilterError(
        message:
            '"failed to parse filter (is.2022-01-01 00:00:00.000)" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "2" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error(DateTime(2022, 1, 1)), expected);
    });

    test('should return the correct error when \'baseValue\' is range', () {
      const expected = FilterError(
        message: '"failed to parse filter (is.[10,20])" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "[" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error(RangeType.createRange(range: '[10,20]')), expected);
    });

    test('should return the correct error when \'baseValue\' is map', () {
      const expected = FilterError(
        message: '"failed to parse filter (is.{value: 10})" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "{" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error({'value': 10}), expected);
    });

    test('should return the correct error when \'baseValue\' is empty list',
        () {
      const expected = FilterError(
        message: '"failed to parse filter (is.[])" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "[" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error([]), expected);
    });

    test('should return the correct error when \'baseValue\' is null list', () {
      const expected = FilterError(
        message:
            '"failed to parse filter (is.[null, null, null])" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "[" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error([null, null, null]), expected);
    });

    test('should return the correct error when \'baseValue\' is int list', () {
      const expected = FilterError(
        message:
            '"failed to parse filter (is.[1, 2, 3, 4])" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "[" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error([1, 2, 3, 4]), expected);
    });

    test('should return the correct error when \'baseValue\' is double list',
        () {
      const expected = FilterError(
        message:
            '"failed to parse filter (is.[1.5, 2.5, 3.5, 4.5])" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "[" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error([1.5, 2.5, 3.5, 4.5]), expected);
    });

    test('should return the correct error when \'baseValue\' is string list',
        () {
      const expected = FilterError(
        message:
            '"failed to parse filter (is.[1, 2, 3, 4])" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "[" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error(['1', '2', '3', '4']), expected);
    });

    test('should return the correct error when \'baseValue\' is bool list', () {
      const expected = FilterError(
        message:
            '"failed to parse filter (is.[false, true, false, true])" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "[" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(error([false, true, false, true]), expected);
    });

    test('should return the correct error when \'baseValue\' is datetime list',
        () {
      const expected = FilterError(
        message:
            '"failed to parse filter (is.[2022-01-01 00:00:00.000, 2022-12-31 00:00:00.000])" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "[" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(
        error(
          [
            DateTime(2022, 1, 1),
            DateTime(2022, 12, 31),
          ],
        ),
        expected,
      );
    });

    test('should return the correct error when \'baseValue\' is range list',
        () {
      const expected = FilterError(
        message:
            '"failed to parse filter (is.[[10,20], [30,40]])" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "[" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(
        error(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
          ],
        ),
        expected,
      );
    });

    test('should return the correct error when \'baseValue\' is map list', () {
      const expected = FilterError(
        message:
            '"failed to parse filter (is.[{value: 10}, {value: 20}])" (line 1, column 4)',
        code: 'PGRST100',
        details:
            'unexpected "[" expecting null or trilean value (unknown, true, false)',
        hint: null,
      );

      expect(
        error(
          [
            {'value': 10},
            {'value': 20},
          ],
        ),
        expected,
      );
    });
  });

  group('invalid input syntax error', () {
    late final FilterError Function(
      dynamic baseValue,
      dynamic castValue,
      bool grabOnlyFirstElement,
    ) error;

    setUpAll(() {
      error = (
        baseValue,
        castValue,
        grabOnlyFirstElement,
      ) =>
          errorBuilder.invalidInputSyntaxError(
            baseValue,
            castValue,
            grabOnlyFirstElement,
          );
    });

    test('should return the correct error when \'baseValue\' is int', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(22, 22, false), expected);
    });

    test('should return the correct error when \'baseValue\' is double', () {
      const expected = FilterError(
        message: 'invalid input syntax for type double precision: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(22.5, 22, false), expected);
    });

    test('should return the correct error when \'baseValue\' is string', () {
      const expected = FilterError(
        message: 'invalid input syntax for type text: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error('string sample', 22, false), expected);
    });

    test('should return the correct error when \'baseValue\' is bool', () {
      const expected = FilterError(
        message: 'invalid input syntax for type boolean: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(true, 22, false), expected);
    });

    test('should return the correct error when \'baseValue\' is datetime', () {
      const expected = FilterError(
        message: 'invalid input syntax for type timestamp with time zone: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(DateTime(2022, 1, 1), 22, false), expected);
    });

    test('should return the correct error when \'baseValue\' is range', () {
      const expected = FilterError(
        message: 'invalid input syntax for type range: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(RangeType.createRange(range: '[10,20]'), 22, false),
        expected,
      );
    });

    test('should return the correct error when \'baseValue\' is map', () {
      const expected = FilterError(
        message: 'invalid input syntax for type jsonb: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error({'value': 10}, 22, false), expected);
    });

    test('should return the correct error when \'baseValue\' is empty list',
        () {
      const expected = FilterError(
        message: 'invalid input syntax for type null or empty list[]: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([], 22, false), expected);
    });

    test('should return the correct error when \'baseValue\' is null list', () {
      const expected = FilterError(
        message: 'invalid input syntax for type null or empty list[]: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([null, null, null], 22, false), expected);
    });

    test('should return the correct error when \'baseValue\' is int list', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int[]: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([1, 2, 3, 4], 22, false), expected);
    });

    test('should return the correct error when \'baseValue\' is double list',
        () {
      const expected = FilterError(
        message: 'invalid input syntax for type double precision[]: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([1.5, 2.5, 3.5, 4.5], 22, false), expected);
    });

    test('should return the correct error when \'baseValue\' is string list',
        () {
      const expected = FilterError(
        message: 'invalid input syntax for type text[]: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(['1', '2', '3', '4'], 22, false), expected);
    });

    test('should return the correct error when \'baseValue\' is bool list', () {
      const expected = FilterError(
        message: 'invalid input syntax for type boolean[]: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error([false, true, false, true], 22, false), expected);
    });

    test('should return the correct error when \'baseValue\' is datetime list',
        () {
      const expected = FilterError(
        message:
            'invalid input syntax for type timestamp with time zone[]: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(
          [
            DateTime(2022, 1, 1),
            DateTime(2022, 12, 31),
          ],
          22,
          false,
        ),
        expected,
      );
    });

    test('should return the correct error when \'baseValue\' is range list',
        () {
      const expected = FilterError(
        message: 'invalid input syntax for type range[]: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
          ],
          22,
          false,
        ),
        expected,
      );
    });

    test('should return the correct error when \'baseValue\' is map list', () {
      const expected = FilterError(
        message: 'invalid input syntax for type jsonb[]: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(
          [
            {'value': 10},
            {'value': 20},
          ],
          22,
          false,
        ),
        expected,
      );
    });

    test(
        'should return the entire value if \'grabOnlyFirstElement\' is not used with a list',
        () {
      const expected = FilterError(
        message: 'invalid input syntax for type text: "22.5"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error('sample string', 22.5, true), expected);
    });

    test(
        'should return the first element if \'grabOnlyFirstElement\' is used with a list',
        () {
      const expected = FilterError(
        message: 'invalid input syntax for type text: "1"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error('sample string', [1, 2, 3, 4], true), expected);
    });

    test(
        'should return the first element if \'grabOnlyFirstElement\' is used with a postgres list',
        () {
      const expected = FilterError(
        message: 'invalid input syntax for type text: "1"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error('sample string', '{1, 2, 3, 4}', true), expected);
    });

    test(
        'should return an empty postgres list if \'grabOnlyFirstElement\' is used with an empty list',
        () {
      const expected = FilterError(
        message: 'invalid input syntax for type text: "{}"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error('sample string', [], true), expected);
    });

    test('should return the correct error when \'castValue\' is int', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "22"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(22, 22, false), expected);
    });

    test('should return the correct error when \'castValue\' is double', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "22.5"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(22, 22.5, false), expected);
    });

    test('should return the correct error when \'castValue\' is string', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "sample string"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(22, 'sample string', false), expected);
    });

    test('should return the correct error when \'castValue\' is bool', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "true"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(22, true, false), expected);
    });

    test('should return the correct error when \'castValue\' is datetime', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "2022-01-01 00:00:00.000"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(error(22, DateTime(2022, 1, 1), false), expected);
    });

    test('should return the correct error when \'castValue\' is range', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "[10,20]"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(22, RangeType.createRange(range: '[10,20]'), false),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is json', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "{value: 10}"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(22, {'value': 10}, false),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is json', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "null"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(22, null, false),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is empty list',
        () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "{}"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(22, [], false),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is null list', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "{null, null, null}"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(22, [null, null, null], false),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is int list', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "{1, 2, 3, 4}"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(22, [1, 2, 3, 4], false),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is double list',
        () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "{1.5, 2.5, 3.5, 4.5}"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(22, [1.5, 2.5, 3.5, 4.5], false),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is string list',
        () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "{1, 2, 3, 4}"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(22, ['1', '2', '3', '4'], false),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is bool list', () {
      const expected = FilterError(
        message:
            'invalid input syntax for type int: "{true, false, true, false}"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(22, [true, false, true, false], false),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is bool list', () {
      const expected = FilterError(
        message:
            'invalid input syntax for type int: "{2022-01-01 00:00:00.000, 2022-12-31 00:00:00.000}"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(22, [DateTime(2022, 1, 1), DateTime(2022, 12, 31)], false),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is bool list', () {
      const expected = FilterError(
        message: 'invalid input syntax for type int: "{[10,20], [30,40]}"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(
          22,
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
          ],
          false,
        ),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is map list', () {
      const expected = FilterError(
        message:
            'invalid input syntax for type int: "{{value: 10}, {value: 20}}"',
        code: '22P02',
        details: 'Bad Request',
        hint: null,
      );

      expect(
        error(
          22,
          [
            {'value': 10},
            {'value': 20},
          ],
          false,
        ),
        expected,
      );
    });
  });

  group('datetime out of range error', () {
    late final FilterError Function(
      dynamic castValue,
    ) error;

    setUpAll(() {
      error = (castValue) => errorBuilder.datetimeOutOfRange(castValue);
    });

    test('should return the correct error when \'castValue\' is int', () {
      const expected = FilterError(
        message: 'date/time field value out of range: "22"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error(22), expected);
    });

    test('should return the correct error when \'castValue\' is double', () {
      const expected = FilterError(
        message: 'date/time field value out of range: "22.5"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error(22.5), expected);
    });

    test('should return the correct error when \'castValue\' is string', () {
      const expected = FilterError(
        message: 'date/time field value out of range: "string sample"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error('string sample'), expected);
    });

    test('should return the correct error when \'castValue\' is bool', () {
      const expected = FilterError(
        message: 'date/time field value out of range: "true"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error(true), expected);
    });

    test('should return the correct error when \'castValue\' is datetime', () {
      const expected = FilterError(
        message:
            'date/time field value out of range: "2022-01-01 00:00:00.000"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error(DateTime(2022, 1, 1)), expected);
    });

    test('should return the correct error when \'castValue\' is range', () {
      const expected = FilterError(
        message: 'date/time field value out of range: "[10,20]"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error(RangeType.createRange(range: '[10,20]')), expected);
    });

    test('should return the correct error when \'castValue\' is map', () {
      const expected = FilterError(
        message: 'date/time field value out of range: "{value: 10}"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error({'value': 10}), expected);
    });

    test('should return the correct error when \'castValue\' is null', () {
      const expected = FilterError(
        message: 'date/time field value out of range: "null"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error(null), expected);
    });

    test('should return the correct error when \'castValue\' is empty list',
        () {
      const expected = FilterError(
        message: 'date/time field value out of range: "{}"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error([]), expected);
    });

    test('should return the correct error when \'castValue\' is null list', () {
      const expected = FilterError(
        message: 'date/time field value out of range: "{null, null, null}"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error([null, null, null]), expected);
    });

    test('should return the correct error when \'castValue\' is int list', () {
      const expected = FilterError(
        message: 'date/time field value out of range: "{1, 2, 3, 4}"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error([1, 2, 3, 4]), expected);
    });

    test('should return the correct error when \'castValue\' is double list',
        () {
      const expected = FilterError(
        message: 'date/time field value out of range: "{1.5, 2.5, 3.5, 4.5}"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error([1.5, 2.5, 3.5, 4.5]), expected);
    });

    test('should return the correct error when \'castValue\' is string list',
        () {
      const expected = FilterError(
        message: 'date/time field value out of range: "{"1", "2", "3", "4"}"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error(['1', '2', '3', '4']), expected);
    });

    test('should return the correct error when \'castValue\' is bool list', () {
      const expected = FilterError(
        message:
            'date/time field value out of range: "{false, true, false, true}"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(error([false, true, false, true]), expected);
    });

    test('should return the correct error when \'castValue\' is datetime list',
        () {
      const expected = FilterError(
        message:
            'date/time field value out of range: "{2022-01-01 00:00:00.000, 2022-12-31 00:00:00.000}"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(
        error(
          [
            DateTime(2022, 1, 1),
            DateTime(2022, 12, 31),
          ],
        ),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is range list',
        () {
      const expected = FilterError(
        message: 'date/time field value out of range: "{[10,20], [30,40]}"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(
        error(
          [
            RangeType.createRange(range: '[10,20]'),
            RangeType.createRange(range: '[30,40]'),
          ],
        ),
        expected,
      );
    });

    test('should return the correct error when \'castValue\' is map list', () {
      const expected = FilterError(
        message:
            'date/time field value out of range: "{{value: 10}, {value: 20}}"',
        code: '22008',
        details: 'Bad Request',
        hint: 'Perhaps you need a different "datestyle" setting',
      );

      expect(
        error(
          [
            {'value': 10},
            {'value': 20},
          ],
        ),
        expected,
      );
    });
  });
}
