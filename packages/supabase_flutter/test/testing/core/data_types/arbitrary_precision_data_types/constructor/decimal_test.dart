import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should trim extra spaces', () {
    final numeric = Decimal(value: '   213213.213  ', scale: 5, precision: 14);
    final expected = Decimal(value: '000213213.21300', scale: 5, precision: 14);
    expect(numeric.identicalTo(expected), true);
  });

  test(
      'should return a fractional numeric if both scale and precision have the same value',
      () {
    final numeric = Decimal(value: '0.14', scale: 2, precision: 2);
    expect(numeric, Decimal(value: '0.14', scale: 2, precision: 2));
  });

  test('should not count the leading 0 as a digit in a fractional numeric', () {
    final numeric = Decimal(value: '3.14', scale: 2, precision: 2);
    expect(numeric, Decimal(value: '0.14', scale: 2, precision: 2));
  });

  test('should allow negative scale', () {
    final numeric = Decimal(precision: 5, scale: -2, value: '0');
    expect(numeric.precision, 5);
    expect(numeric.scale, -2);
  });

  test('should throw ArgumentError if precision is negative', () {
    expect(() => Decimal(precision: -1, value: '0'), throwsArgumentError);
  });

  test('should throw ArgumentError if scale is given but precision is null',
      () {
    expect(() => Decimal(scale: 2, value: '0'), throwsArgumentError);
  });

  test('should throw an ArgumentError if precision exceeds the maximum value',
      () {
    expect(
      () => Decimal(value: '1.5', precision: 700000),
      throwsArgumentError,
    );
  });

  test('should throw an ArgumentError if scale is greater than precision', () {
    expect(
      () => Decimal(value: '1.5', precision: 3, scale: 4),
      throwsArgumentError,
    );
  });

  group('string validation', () {
    test('should throw an ArgumentError if the value is empty', () {
      expect(() => Decimal(value: ''), throwsArgumentError);
    });

    test('should throw an ArgumentError if the value only contains spaces', () {
      expect(() => Decimal(value: '      '), throwsArgumentError);
    });

    test(
        'should throw an ArgumentError if value does not contain at least one number',
        () {
      expect(() => Decimal(value: '-ajdo.iajsdo'), throwsArgumentError);
    });

    test('should throw an ArgumentError if value contains letters', () {
      expect(() => Decimal(value: '-aj12o.ia123do'), throwsArgumentError);
    });

    test('should throw an ArgumentError if value contains more than one hyphen',
        () {
      expect(() => Decimal(value: '-123.45-6'), throwsArgumentError);
    });

    test(
        'should throw an ArgumentError if the hyphen is in an incorrect position',
        () {
      expect(() => Decimal(value: '12-3.456'), throwsArgumentError);
    });

    test(
        'should throw an ArgumentError if the hyphen is in the end of the value',
        () {
      expect(() => Decimal(value: '123.456-'), throwsArgumentError);
    });

    test(
        'should throw an ArgumentError if the value contains more than one fractional point',
        () {
      expect(() => Decimal(value: '12.3.456'), throwsArgumentError);
    });

    test(
        'should throw an ArgumentError if the fractional point is in the beginning of the value',
        () {
      expect(() => Decimal(value: '.123456'), throwsArgumentError);
    });

    test(
        'should throw an ArgumentError if the fractional point is in the end of the value',
        () {
      expect(() => Decimal(value: '123456.'), throwsArgumentError);
    });

    test(
        'should throw an ArgumentError if the fractional point is right after the hyphen',
        () {
      expect(() => Decimal(value: '-.123456'), throwsArgumentError);
    });

    test(
        'should throw an ArgumentError if the fractional point is before the hyphen',
        () {
      expect(() => Decimal(value: '.-123456'), throwsArgumentError);
    });

    test('should throw an ArgumentError if string is not a valid number', () {
      expect(
        () => Decimal(value: '3i.1a4v', scale: 4, precision: 6),
        throwsArgumentError,
      );
    });
  });
}
