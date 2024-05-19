import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  group('positive values', () {
    test('should return the max value relatively to the precision and scale ',
        () {
      expect(Decimal(value: '1.5', precision: 5, scale: 3).maxValue, '99.999');
    });

    test('should return max value if value is int', () {
      expect(Decimal(value: '0', precision: 5, scale: 0).maxValue, '99999');
    });

    test(
        'should return max value as largest representable amount for that precision if value is unconstrained',
        () {
      expect(Decimal(value: '3.1415').maxValue, '9.9999');
    });

    test('should return max value if value is unconstrained int', () {
      expect(Decimal(value: '8264').maxValue, '9999');
    });

    test('should return max value if scale is negative', () {
      expect(
        Decimal(value: '0', precision: 5, scale: -2).maxValue,
        '9' * 5,
      );
    });

    test('should return max value if value is fractional', () {
      expect(
        Decimal(value: '0.35', precision: 2, scale: 2).maxValue,
        '0.99',
      );
    });
  });

  group('negative values', () {
    test('should return the max value relatively to the precision and scale ',
        () {
      expect(Decimal(value: '-1.5', precision: 5, scale: 3).maxValue, '99.999');
    });

    test(
        'should return max value as largest representable amount for that precision if value is unconstrained',
        () {
      expect(Decimal(value: '-3.1415').maxValue, '99.9999');
    });

    test('should return max value if value is unconstrained int', () {
      expect(Decimal(value: '-8264').maxValue, '9999');
    });

    test('should return max value if scale is negative', () {
      expect(
        Decimal(value: '-13421', precision: 5, scale: -4).maxValue,
        '9' * 5,
      );
    });

    test('should return max value if value is fractional', () {
      expect(
        Decimal(value: '-0.35', precision: 2, scale: 2).maxValue,
        '0.99',
      );
    });
  });
}
