import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should work correctly with positive values', () {
    final value = Real(3.2);
    final expected = Real(3);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative values', () {
    final value = Real(-3.7);
    final expected = Real(-4);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is a positive whole number', () {
    final value = Real(5);
    final expected = Real(5);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is a negative whole number', () {
    final value = Real(-2);
    final expected = Real(-2);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should return 0.0 if value is 0.0', () {
    final value = Real(0.0);
    final expected = Real(0.0);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle fractionally small near-zero positive value',
      () {
    final value = Real(0.00001);
    final expected = Real(0);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle fractionally small near-zero positive value',
      () {
    final value = Real(-0.00001);
    final expected = Real(-1);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle positive numbers very close to an integer', () {
    final value = Real(2.99999);
    final expected = Real(2);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle negative numbers very close to an integer', () {
    final value = Real(-2.99999);
    final expected = Real(-3);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle positive values with small fractional part',
      () {
    final value = Real(1.00001);
    final expected = Real(1);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle negative values with small fractional part',
      () {
    final value = Real(-1.00001);
    final expected = Real(-2);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });
}
