import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should round up if positive value has .5 fractional part', () {
    final value = Numeric(value: '0.5', precision: 1, scale: 1);
    final expected = Numeric(value: '1.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if positive value has fractional part greater than .5',
      () {
    final value = Numeric(value: '0.7', precision: 1, scale: 1);
    final expected = Numeric(value: '1.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if positive value has fractional part less than .5',
      () {
    final value = Numeric(value: '0.2', precision: 1, scale: 1);
    final expected = Numeric(value: '0.0', precision: 1, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if negative value has .5 fractional part', () {
    final value = Numeric(value: '-0.5', precision: 1, scale: 1);
    final expected = Numeric(value: '-1.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if negative value has fractional part greater than .5',
      () {
    final value = Numeric(value: '-0.7', precision: 1, scale: 1);
    final expected = Numeric(value: '-1.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if negative value has fractional part less than .5',
      () {
    final value = Numeric(value: '-0.2', precision: 1, scale: 1);
    final expected = Numeric(value: '-0.0', precision: 1, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return 1 if value is 0.5', () {
    final value = Numeric(value: '0.5', precision: 1, scale: 1);
    final expected = Numeric(value: '1.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return -1 if value is -0.5', () {
    final value = Numeric(value: '-0.5', precision: 1, scale: 1);
    final expected = Numeric(value: '-1.0', precision: 2, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return 0.0 if value is 0.0', () {
    final value = Numeric(value: '0.0', precision: 1, scale: 1);
    final expected = Numeric(value: '0.0', precision: 1, scale: 1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with positive values very close to zero', () {
    final value = Numeric(value: '0.49999999999999', precision: 14, scale: 14);
    final expected = Numeric(
      value: '0.00000000000000',
      precision: 14,
      scale: 14,
    );
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative values very close to zero', () {
    final value = Numeric(value: '-0.49999999999999', precision: 14, scale: 14);
    final expected = Numeric(
      value: '0.00000000000000',
      precision: 14,
      scale: 14,
    );
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if positive value is slightly above .5', () {
    final value = Numeric(value: '0.50000000000001', precision: 14, scale: 14);
    final expected = Numeric(
      value: '1.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if positive value is slightly below .5', () {
    final value = Numeric(value: '0.49999999999999', precision: 14, scale: 14);
    final expected = Numeric(
      value: '0.00000000000000',
      precision: 14,
      scale: 14,
    );
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if negative value is slightly above .5', () {
    final value = Numeric(value: '-0.50000000000001', precision: 14, scale: 14);
    final expected = Numeric(
      value: '-1.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if negative value is slightly below .5', () {
    final value = Numeric(value: '-0.49999999999999', precision: 14, scale: 14);
    final expected = Numeric(
      value: '-0.00000000000000',
      precision: 14,
      scale: 14,
    );
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });
}
