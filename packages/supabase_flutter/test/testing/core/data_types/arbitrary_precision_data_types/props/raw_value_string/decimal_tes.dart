import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should treat the value normally if precision and scale are respected',
      () {
    final numeric = Decimal(value: '22.765', precision: 5, scale: 3);
    expect(numeric.rawValueString, '22.765');
  });

  test(
      'should add leading 0s if precision is greater than the length of numbers before the fraction point',
      () {
    final numeric = Decimal(value: '22.765', precision: 8, scale: 3);
    expect(numeric.rawValueString, '00022.765');
  });

  test(
      'should cut numbers if precision is less than the length of numbers before the fraction point',
      () {
    final numeric = Decimal(value: '22.765', precision: 4, scale: 3);
    expect(numeric.rawValueString, '2.765');
  });

  test(
      'should only consider the numbers after the fractional point if scale is equal to precision',
      () {
    final numeric = Decimal(value: '22.765', precision: 3, scale: 3);
    expect(numeric.rawValueString, '0.765');
  });

  test('should remove the fractional part if scale is not specified', () {
    final numeric = Decimal(value: '22.765', precision: 3);
    expect(numeric.rawValueString, '022');
  });

  test(
      'should return a value that is as big as it needs to be if neither scale nor precision are specified',
      () {
    final numeric = Decimal(value: '93821382193821982913122.7653129');
    expect(numeric.rawValueString, '93821382193821982913122.7653129');
  });

  test(
      'should add trailing 0s if scale is greater than the length of numbers before the fraction point',
      () {
    final numeric = Decimal(value: '22.7', precision: 3, scale: 3);
    expect(numeric.rawValueString, '0.700');
  });

  test(
      'should cut numbers if scale is less than the length of numbers before the fraction point',
      () {
    final numeric = Decimal(value: '22.76598190', precision: 3, scale: 3);
    expect(numeric.rawValueString, '0.765');
  });

  test(
      'should round numbers to the nearest multiple of 10 if scale is negative',
      () {
    // 1300 because 10 ** 2 = 100, therefore rounding 1322 to the closest hundred is 1300
    final numeric = Decimal(value: '1322.76598190', precision: 3, scale: -2);
    expect(numeric.rawValueString, '1300');
  });

  test('should round to 0 if the negative scale is too great', () {
    // 1300 because 10 ** 10 = 10000000000, therefore rounding 1322 to the closest hundred is 0
    final numeric = Decimal(value: '1322.76598190', precision: 3, scale: -10);
    expect(numeric.rawValueString, '0');
  });

  test('should display correctly positive fractional values', () {
    final numeric = Decimal(value: '0.34', precision: 2, scale: 2);
    expect(numeric.rawValueString, '0.34');
  });

  test('should display correctly negative fractional values', () {
    final numeric = Decimal(value: '-0.34', precision: 2, scale: 2);
    expect(numeric.rawValueString, '-0.34');
  });
}
