import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should work correctly with positive values', () {
    final value = DoublePrecision(3.2);
    final expected = DoublePrecision(3);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative values', () {
    final value = DoublePrecision(-3.7);
    final expected = DoublePrecision(-4);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is a positive whole number', () {
    final value = DoublePrecision(5);
    final expected = DoublePrecision(5);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is a negative whole number', () {
    final value = DoublePrecision(-2);
    final expected = DoublePrecision(-2);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should return 0.0 if value is 0.0', () {
    final value = DoublePrecision(0.0);
    final expected = DoublePrecision(0.0);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle fractionally small near-zero positive value',
      () {
    final value = DoublePrecision(0.00000000000001);
    final expected = DoublePrecision(0);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle fractionally small near-zero positive value',
      () {
    final value = DoublePrecision(-0.00000000000001);
    final expected = DoublePrecision(-1);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle positive numbers very close to an integer', () {
    final value = DoublePrecision(2.99999999999999);
    final expected = DoublePrecision(2);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle negative numbers very close to an integer', () {
    final value = DoublePrecision(-2.99999999999999);
    final expected = DoublePrecision(-3);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle positive values with small fractional part',
      () {
    final value = DoublePrecision(1.00000000000001);
    final expected = DoublePrecision(1);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle negative values with small fractional part',
      () {
    final value = DoublePrecision(-1.00000000000001);
    final expected = DoublePrecision(-2);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });
}
