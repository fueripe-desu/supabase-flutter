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
}
