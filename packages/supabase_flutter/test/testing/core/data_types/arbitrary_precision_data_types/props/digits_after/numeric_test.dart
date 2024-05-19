import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  group('positive values', () {
    test(
        'should return the amount of expected digits after the fractional point',
        () {
      final numeric = Numeric(value: '1.5', precision: 5, scale: 3);
      expect(numeric.digitsAfter, 3);
    });

    test('should return 0 if scale is not given', () {
      final numeric = Numeric(value: '1.5', precision: 5);
      expect(numeric.digitsAfter, 0);
    });

    test('should return the implementation limit if Numeric is unconstrained',
        () {
      final numeric = Numeric(value: '1.5');
      expect(numeric.digitsAfter, Numeric.maxDigitsAfter);
    });

    test('should return 0 if scale is negative', () {
      final numeric = Numeric(value: '1.5', precision: 5, scale: -2);
      expect(numeric.digitsAfter, 0);
    });

    test('should return 0 if value is int', () {
      final numeric = Numeric(value: '43', precision: 2, scale: 0);
      expect(numeric.digitsAfter, 0);
    });

    test('should return the scale if value is fractional', () {
      final numeric = Numeric(value: '0.3', precision: 1, scale: 1);
      expect(numeric.digitsAfter, 1);
    });
  });

  group('negative values', () {
    test(
        'should return the amount of expected digits after the fractional point',
        () {
      final numeric = Numeric(value: '-1.5', precision: 5, scale: 3);
      expect(numeric.digitsAfter, 3);
    });

    test('should return 0 if scale is not given', () {
      final numeric = Numeric(value: '-1.5', precision: 5);
      expect(numeric.digitsAfter, 0);
    });

    test('should return the implementation limit if Numeric is unconstrained',
        () {
      final numeric = Numeric(value: '-1.5');
      expect(numeric.digitsAfter, Numeric.maxDigitsAfter);
    });

    test('should return 0 if scale is negative', () {
      final numeric = Numeric(value: '-1.5', precision: 5, scale: -2);
      expect(numeric.digitsAfter, 0);
    });

    test('should return 0 if value is int', () {
      final numeric = Numeric(value: '-43', precision: 2, scale: 0);
      expect(numeric.digitsAfter, 0);
    });

    test('should return the scale if value is fractional', () {
      final numeric = Numeric(value: '-0.3', precision: 1, scale: 1);
      expect(numeric.digitsAfter, 1);
    });
  });
}
