import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should round up if positive value has .5 fractional part', () {
    final value = Real(3.5);
    final expected = Real(4);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if positive value has fractional part greater than .5',
      () {
    final value = Real(3.7);
    final expected = Real(4);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if positive value has fractional part less than .5',
      () {
    final value = Real(3.2);
    final expected = Real(3);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if negative value has .5 fractional part', () {
    final value = Real(-3.5);
    final expected = Real(-4);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if negative value has fractional part greater than .5',
      () {
    final value = Real(-3.7);
    final expected = Real(-4);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if negative value has fractional part less than .5',
      () {
    final value = Real(-3.2);
    final expected = Real(-3);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return 1 if value is 0.5', () {
    final value = Real(0.5);
    final expected = Real(1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return -1 if value is -0.5', () {
    final value = Real(-0.5);
    final expected = Real(-1);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return 0.0 if value is 0.0', () {
    final value = Real(0.0);
    final expected = Real(0.0);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with positive values very close to zero', () {
    final value = Real(0.49999);
    final expected = Real(0.0);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative values very close to zero', () {
    final value = Real(-0.49999);
    final expected = Real(0.0);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if positive value is slightly above .5', () {
    final value = Real(2.50001);
    final expected = Real(3);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if positive value is slightly below .5', () {
    final value = Real(2.49999);
    final expected = Real(2);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round up if negative value is slightly above .5', () {
    final value = Real(-2.50001);
    final expected = Real(-3);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round down if negative value is slightly below .5', () {
    final value = Real(-2.49999);
    final expected = Real(-2);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very large numbers', () {
    final value = Real(1e37);
    final expected = Real(1e37);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very small numbers', () {
    final value = Real(-1e37);
    final expected = Real(-1e37);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should round with precision even complex floating point', () {
    final value = Real(123456789.987654321);
    final expected = Real(123456790);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });
}
