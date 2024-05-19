import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  group('positive values', () {
    test(
        'should return the amount of expected digits before the fractional point',
        () {
      final numeric = Decimal(value: '1.5', precision: 5, scale: 3);
      expect(numeric.digitsBefore, 2);
    });

    test('should return the implementation limit if value is unconstrained',
        () {
      final numeric = Decimal(value: '1.5');
      expect(numeric.digitsBefore, Decimal.maxDigitsBefore);
    });

    test('should return the amount of digits if value is int', () {
      final numeric = Decimal(value: '20', precision: 2, scale: 0);
      expect(numeric.digitsBefore, 2);
    });

    test('should return the amount of digits if value has negative scale', () {
      final numeric = Decimal(value: '54', precision: 2, scale: -1);
      expect(numeric.digitsBefore, 2);
    });

    test('should return 0 if value is fractional', () {
      final numeric = Decimal(value: '0.14', precision: 2, scale: 2);
      expect(numeric.digitsBefore, 0);
    });
  });

  group('negative values', () {
    test(
        'should return the amount of expected digits before the fractional point',
        () {
      final numeric = Decimal(value: '-1.5', precision: 5, scale: 3);
      expect(numeric.digitsBefore, 2);
    });

    test('should return the implementation limit if value is unconstrained',
        () {
      final numeric = Decimal(value: '-1.5');
      expect(numeric.digitsBefore, Decimal.maxDigitsBefore);
    });

    test('should return the amount of digits if value is int', () {
      final numeric = Decimal(value: '-20', precision: 2, scale: 0);
      expect(numeric.digitsBefore, 2);
    });

    test('should return the amount of digits if value has negative scale', () {
      final numeric = Decimal(value: '-54', precision: 2, scale: -1);
      expect(numeric.digitsBefore, 2);
    });

    test('should return 0 if value is fractional', () {
      final numeric = Decimal(value: '-0.14', precision: 2, scale: 2);
      expect(numeric.digitsBefore, 0);
    });
  });
}
