import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should round up if positive value has .5 fractional part', () {
    final value = DoublePrecision(3.5);
    final expected = DoublePrecision(4);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if positive value has fractional part greater than .5',
      () {
    final value = DoublePrecision(3.7);
    final expected = DoublePrecision(4);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if positive value has fractional part less than .5',
      () {
    final value = DoublePrecision(3.2);
    final expected = DoublePrecision(3);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if negative value has .5 fractional part', () {
    final value = DoublePrecision(-3.5);
    final expected = DoublePrecision(-4);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if negative value has fractional part greater than .5',
      () {
    final value = DoublePrecision(-3.7);
    final expected = DoublePrecision(-4);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if negative value has fractional part less than .5',
      () {
    final value = DoublePrecision(-3.2);
    final expected = DoublePrecision(-3);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return 1 if value is 0.5', () {
    final value = DoublePrecision(0.5);
    final expected = DoublePrecision(1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return -1 if value is -0.5', () {
    final value = DoublePrecision(-0.5);
    final expected = DoublePrecision(-1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return 0.0 if value is 0.0', () {
    final value = DoublePrecision(0.0);
    final expected = DoublePrecision(0.0);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with positive values very close to zero', () {
    final value = DoublePrecision(0.49999999999999);
    final expected = DoublePrecision(0.0);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative values very close to zero', () {
    final value = DoublePrecision(-0.49999999999999);
    final expected = DoublePrecision(0.0);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if positive value is slightly above .5', () {
    final value = DoublePrecision(2.50000000000001);
    final expected = DoublePrecision(3);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if positive value is slightly below .5', () {
    final value = DoublePrecision(2.49999999999999);
    final expected = DoublePrecision(2);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if negative value is slightly above .5', () {
    final value = DoublePrecision(-2.50000000000001);
    final expected = DoublePrecision(-3);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if negative value is slightly below .5', () {
    final value = DoublePrecision(-2.49999999999999);
    final expected = DoublePrecision(-2);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very large numbers', () {
    final value = DoublePrecision(1e37);
    final expected = DoublePrecision(1e37);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very small numbers', () {
    final value = DoublePrecision(-1e307);
    final expected = DoublePrecision(-1e307);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round with precision even complex floating point', () {
    final value = DoublePrecision(123456789.987654321);
    final expected = DoublePrecision(123456790);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });
}
