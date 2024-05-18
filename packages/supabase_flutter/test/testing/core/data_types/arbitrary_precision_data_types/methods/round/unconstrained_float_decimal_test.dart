import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should round up if positive value has .5 fractional part', () {
    final value = Decimal(value: '3.5');
    final expected = Decimal(value: '4.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if positive value has fractional part greater than .5',
      () {
    final value = Decimal(value: '3.7');
    final expected = Decimal(value: '4.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if positive value has fractional part less than .5',
      () {
    final value = Decimal(value: '3.2');
    final expected = Decimal(value: '3.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if negative value has .5 fractional part', () {
    final value = Decimal(value: '-3.5');
    final expected = Decimal(value: '-4.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if negative value has fractional part greater than .5',
      () {
    final value = Decimal(value: '-3.7');
    final expected = Decimal(value: '-4.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if negative value has fractional part less than .5',
      () {
    final value = Decimal(value: '-3.2');
    final expected = Decimal(value: '-3.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return 1 if value is 0.5', () {
    final value = Decimal(value: '0.5');
    final expected = Decimal(value: '1.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return -1 if value is -0.5', () {
    final value = Decimal(value: '-0.5');
    final expected = Decimal(value: '-1.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return 0.0 if value is 0.0', () {
    final value = Decimal(value: '0.0');
    final expected = Decimal(value: '0.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with positive values very close to zero', () {
    final value = Decimal(value: '0.49999999999999');
    final expected = Decimal(
      value: '0.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative values very close to zero', () {
    final value = Decimal(value: '-0.49999999999999');
    final expected = Decimal(
      value: '0.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if positive value is slightly above .5', () {
    final value = Decimal(value: '2.50000000000001');
    final expected = Decimal(
      value: '3.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if positive value is slightly below .5', () {
    final value = Decimal(value: '2.49999999999999');
    final expected = Decimal(
      value: '2.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if negative value is slightly above .5', () {
    final value = Decimal(value: '-2.50000000000001');
    final expected = Decimal(
      value: '-3.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if negative value is slightly below .5', () {
    final value = Decimal(value: '-2.49999999999999');
    final expected = Decimal(
      value: '-2.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very large numbers', () {
    final value = Decimal(value: '1e37');
    final expected = Decimal(value: '1e37', precision: 38, scale: 0);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very small numbers', () {
    final value = Decimal(value: '-1e307');
    final expected = Decimal(value: '-1e307', precision: 308, scale: 0);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round with precision even complex floating point', () {
    final value = Decimal(value: '123456789.987654321');
    final expected = Decimal(value: '123456790.0', precision: 18, scale: 9);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });
}
