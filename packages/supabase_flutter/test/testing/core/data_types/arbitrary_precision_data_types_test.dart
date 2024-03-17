import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  group('numeric tests', () {
    group('constants', () {
      test(
          'should return the maximum amount of digits before the fractional point',
          () {
        expect(Numeric.maxDigitsBefore, 131072);
      });

      test(
          'should return the maximum amount of digits after the fractional point',
          () {
        expect(Numeric.maxDigitsAfter, 16383);
      });
    });
    group('precision and scale properties', () {
      test('should return the precision', () {
        final numeric = Numeric(precision: 5, scale: 3, value: '0');
        expect(numeric.precision, 5);
      });

      test('should return the scale', () {
        final numeric = Numeric(precision: 5, scale: 3, value: '0');
        expect(numeric.scale, 3);
      });

      test('should allow null precision', () {
        final numeric = Numeric(value: '0');
        expect(numeric.precision, null);
      });

      test('should allow null scale if precision is given', () {
        final numeric = Numeric(precision: 5, value: '0');
        expect(numeric.precision, 5);
        expect(numeric.scale, null);
      });

      test('should allow negative scale', () {
        final numeric = Numeric(precision: 5, scale: -2, value: '0');
        expect(numeric.precision, 5);
        expect(numeric.scale, -2);
      });

      test('should throw ArgumentError if precision is negative', () {
        expect(() => Numeric(precision: -1, value: '0'), throwsArgumentError);
      });

      test('should throw ArgumentError if scale is given but precision is null',
          () {
        expect(() => Numeric(scale: 2, value: '0'), throwsArgumentError);
      });

      test(
          'should throw an ArgumentError if precision exceeds the maximum value',
          () {
        expect(
          () => Numeric(value: '1.5', precision: 700000),
          throwsArgumentError,
        );
      });

      test('should throw an ArgumentError if scale is greater than precision',
          () {
        expect(
          () => Numeric(value: '1.5', precision: 3, scale: 4),
          throwsArgumentError,
        );
      });
    });

    group('digitsBefore and digitsAfter properties', () {
      test(
          'should return the amount of expected digits before the fractional point',
          () {
        final numeric = Numeric(value: '1.5', precision: 5, scale: 3);
        expect(numeric.digitsBefore, 2);
      });

      test(
          'should return the amount of expected digits after the fractional point',
          () {
        final numeric = Numeric(value: '1.5', precision: 5, scale: 3);
        expect(numeric.digitsAfter, 3);
      });

      test('should return 0 as digitsAfter if scale is not given', () {
        final numeric = Numeric(value: '1.5', precision: 5);
        expect(numeric.digitsAfter, 0);
      });

      test(
          'should return digitsBefore as the implementation limit if Numeric is unconstrained',
          () {
        final numeric = Numeric(value: '1.5');
        expect(numeric.digitsBefore, Numeric.maxDigitsBefore);
      });

      test(
          'should return digitsAfter as the implementation limit if Numeric is unconstrained',
          () {
        final numeric = Numeric(value: '1.5');
        expect(numeric.digitsAfter, Numeric.maxDigitsAfter);
      });

      test('should return 0 as digitsAfter if scale is negative', () {
        final numeric = Numeric(value: '1.5', precision: 5, scale: -2);
        expect(numeric.digitsAfter, 0);
      });
    });

    group('rawValueString property', () {
      test(
          'should treat the value normally if precision and scale are respected',
          () {
        final numeric = Numeric(value: '22.765', precision: 5, scale: 3);
        expect(numeric.rawValueString, '22.765');
      });

      test(
          'should add leading 0s if precision is greater than the length of numbers before the fraction point',
          () {
        final numeric = Numeric(value: '22.765', precision: 8, scale: 3);
        expect(numeric.rawValueString, '00022.765');
      });

      test(
          'should cut numbers if precision is less than the length of numbers before the fraction point',
          () {
        final numeric = Numeric(value: '22.765', precision: 4, scale: 3);
        expect(numeric.rawValueString, '2.765');
      });

      test(
          'should only consider the numbers after the fractional point if scale is equal to precision',
          () {
        final numeric = Numeric(value: '22.765', precision: 3, scale: 3);
        expect(numeric.rawValueString, '0.765');
      });

      test('should remove fractional part if scale is not specified', () {
        final numeric = Numeric(value: '22.765', precision: 3);
        expect(numeric.rawValueString, '022');
      });

      test(
          'should return a value that is as big as it needs to be if neither scale nor precision are specified',
          () {
        final numeric = Numeric(value: '93821382193821982913122.7653129');
        expect(numeric.rawValueString, '93821382193821982913122.7653129');
      });

      test(
          'should add trailing 0s if scale is greater than the length of numbers before the fraction point',
          () {
        final numeric = Numeric(value: '22.7', precision: 3, scale: 3);
        expect(numeric.rawValueString, '0.700');
      });

      test(
          'should cut numbers if scale is less than the length of numbers before the fraction point',
          () {
        final numeric = Numeric(value: '22.76598190', precision: 3, scale: 3);
        expect(numeric.rawValueString, '0.765');
      });

      test(
          'should round numbers to the nearest multiple of 10 if scale is negative',
          () {
        // 1300 because 10 ** 2 = 100, therefore rounding 1322 to the closest hundred is 1300
        final numeric =
            Numeric(value: '1322.76598190', precision: 3, scale: -2);
        expect(numeric.rawValueString, '1300');
      });

      test('should round to 0 if the negative scale is too great', () {
        // 1300 because 10 ** 2 = 100, therefore rounding 1322 to the closest hundred is 1300
        final numeric =
            Numeric(value: '1322.76598190', precision: 3, scale: -10);
        expect(numeric.rawValueString, '0');
      });
    });

    group('max and min values', () {
      test('should return the max value relatively to the precision and scale ',
          () {
        expect(
          Numeric(value: '1.5', precision: 5, scale: 3).maxValue,
          '99.999',
        );
      });

      test('should return the min value relatively to the precision and scale ',
          () {
        expect(
          Numeric(value: '1.5', precision: 5, scale: 3).minValue,
          '-99.999',
        );
      });

      test(
          'should return max value as integer if Numeric is created without fraction point',
          () {
        expect(
          Numeric(value: '0', precision: 5, scale: 3).maxValue,
          '99999',
        );
      });

      test(
          'should return min value as integer if Numeric is created without fraction point',
          () {
        expect(
          Numeric(value: '0', precision: 5, scale: 3).minValue,
          '-99999',
        );
      });

      test(
          'should return max value as the implementation limit if Numeric is unconstrained',
          () {
        expect(
          Numeric(value: '1.5').maxValue,
          '${'9' * Numeric.maxDigitsBefore}.${'9' * Numeric.maxDigitsAfter}',
        );
      });

      test(
          'should return min value as the implementation limit if Numeric is unconstrained',
          () {
        expect(
          Numeric(value: '1.5').minValue,
          '-${'9' * Numeric.maxDigitsBefore}.${'9' * Numeric.maxDigitsAfter}',
        );
      });

      test(
          'should return max value as int if no fractional point is given to an unconstrained numeric',
          () {
        expect(
          Numeric(value: '0').maxValue,
          '${'9' * Numeric.maxDigitsBefore}${'9' * Numeric.maxDigitsAfter}',
        );
      });

      test(
          'should return min value as int if no fractional point is given to an unconstrained numeric',
          () {
        expect(
          Numeric(value: '0').minValue,
          '-${'9' * Numeric.maxDigitsBefore}${'9' * Numeric.maxDigitsAfter}',
        );
      });

      test('should return max value as int if scale is negative', () {
        expect(
          Numeric(value: '0', precision: 5, scale: -2).maxValue,
          '9' * 5,
        );
      });

      test('should return min value as int if scale is negative', () {
        expect(
          Numeric(value: '0', precision: 5, scale: -2).minValue,
          '-${'9' * 5}',
        );
      });
    });

    group('isUnconstrained getter', () {
      test('should return true if both scale and precision are null', () {
        expect(Numeric(value: '0').isUnconstrained, true);
      });

      test('should return false if scale or precision are given', () {
        expect(Numeric(precision: 10, value: '0').isUnconstrained, false);
      });
    });
  });
}
