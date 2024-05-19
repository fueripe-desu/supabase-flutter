import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  group('positive values', () {
    test('should return the min value relatively to the precision and scale ',
        () {
      expect(Numeric(value: '1.5', precision: 5, scale: 3).minValue, '-99.999');
    });

    test('should return min value if value is int', () {
      expect(Numeric(value: '0', precision: 5, scale: 0).minValue, '-99999');
    });

    test(
        'should return min value as largest representable amount for that precision if value is unconstrained',
        () {
      expect(Numeric(value: '3.1415').minValue, '-9.9999');
    });

    test('should return min value if value is unconstrained int', () {
      expect(Numeric(value: '8264').minValue, '-9999');
    });

    test('should return min value if scale is negative', () {
      expect(
        Numeric(value: '0', precision: 5, scale: -2).minValue,
        '-${'9' * 5}',
      );
    });

    test('should return min value if value is fractional', () {
      expect(
        Numeric(value: '0.35', precision: 2, scale: 2).minValue,
        '-0.99',
      );
    });
  });

  group('negative values', () {
    test('should return the min value relatively to the precision and scale ',
        () {
      expect(
          Numeric(value: '-1.5', precision: 5, scale: 3).minValue, '-99.999');
    });

    test(
        'should return min value as largest representable amount for that precision if value is unconstrained',
        () {
      expect(Numeric(value: '-3.1415').minValue, '-99.9999');
    });

    test('should return min value if value is unconstrained int', () {
      expect(Numeric(value: '-8264').minValue, '-9999');
    });

    test('should return min value if scale is negative', () {
      expect(
        Numeric(value: '-13421', precision: 5, scale: -4).minValue,
        '-${'9' * 5}',
      );
    });

    test('should return min value if value is fractional', () {
      expect(
        Numeric(value: '-0.35', precision: 2, scale: 2).minValue,
        '-0.99',
      );
    });
  });
}
