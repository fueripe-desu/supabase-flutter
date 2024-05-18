import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should not affect if value is within bounds', () {
    final upperLimit = Numeric(value: '1.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '0.0', precision: 2, scale: 1);
    final value = Numeric(value: '0.5', precision: 2, scale: 1);
    final expected = Numeric(value: '0.5', precision: 2, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should clamp if value is above maximum', () {
    final upperLimit = Numeric(value: '1.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '0.0', precision: 2, scale: 1);
    final value = Numeric(value: '1.5', precision: 2, scale: 1);
    final expected = Numeric(value: '1.0', precision: 2, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should clamp if value is below minimum', () {
    final upperLimit = Numeric(value: '1.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '0.0', precision: 2, scale: 1);
    final value = Numeric(value: '-0.1', precision: 2, scale: 1);
    final expected = Numeric(value: '0.0', precision: 2, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should not affect negative if value is within bounds', () {
    final upperLimit = Numeric(value: '-2.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '-4.0', precision: 2, scale: 1);
    final value = Numeric(value: '-3', precision: 1, scale: 0);
    final expected = Numeric(value: '-3', precision: 1, scale: 0);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should clamp negative if value is above maximum', () {
    final upperLimit = Numeric(value: '-2.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '-4.0', precision: 2, scale: 1);
    final value = Numeric(value: '-1.5', precision: 2, scale: 1);
    final expected = Numeric(value: '-2.0', precision: 2, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should clamp negative if value is below minimum', () {
    final upperLimit = Numeric(value: '-2.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '-4.0', precision: 2, scale: 1);
    final value = Numeric(value: '-5.0', precision: 2, scale: 1);
    final expected = Numeric(value: '-4.0', precision: 2, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value is equal to the upper bound', () {
    final upperLimit = Numeric(value: '1.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '0.0', precision: 2, scale: 1);
    final value = Numeric(value: '1.0', precision: 2, scale: 1);
    final expected = Numeric(value: '1.0', precision: 2, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value is equal to the lower bound', () {
    final upperLimit = Numeric(value: '1.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '0.0', precision: 2, scale: 1);
    final value = Numeric(value: '0.0', precision: 2, scale: 1);
    final expected = Numeric(value: '0.0', precision: 2, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if negative value is equal to the lower bound',
      () {
    final lowerLimit = Numeric(value: '-1.0', precision: 2, scale: 1);
    final upperLimit = Numeric(value: '-0.0', precision: 2, scale: 1);
    final value = Numeric(value: '-1.0', precision: 2, scale: 1);
    final expected = Numeric(value: '-1.0', precision: 2, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if negative value is equal to the upper bound',
      () {
    final lowerLimit = Numeric(value: '-1.0', precision: 2, scale: 1);
    final upperLimit = Numeric(value: '-0.0', precision: 2, scale: 1);
    final value = Numeric(value: '-0.0', precision: 2, scale: 1);
    final expected = Numeric(value: '-0.0', precision: 2, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should work correctly if both upper and lower bound are equal and positive',
      () {
    final lowerLimit = Numeric(value: '2.0', precision: 2, scale: 1);
    final upperLimit = Numeric(value: '2.0', precision: 2, scale: 1);
    final value = Numeric(value: '5.0', precision: 2, scale: 1);
    final expected = Numeric(value: '2.0', precision: 2, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should work correctly if both upper and lower bound are equal and negative',
      () {
    final lowerLimit = Numeric(value: '-2.0', precision: 2, scale: 1);
    final upperLimit = Numeric(value: '-2.0', precision: 2, scale: 1);
    final value = Numeric(value: '5.0', precision: 2, scale: 1);
    final expected = Numeric(value: '-2.0', precision: 2, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value very close to the upper bound', () {
    final upperLimit = Numeric(value: '1.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '0.0', precision: 2, scale: 1);
    final value = Numeric(value: '0.99999', precision: 6, scale: 5);
    final expected = Numeric(value: '0.99999', precision: 6, scale: 5);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value very close to the lower bound', () {
    final upperLimit = Numeric(value: '1.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '0.0', precision: 2, scale: 1);
    final value = Numeric(value: '0.11111', precision: 6, scale: 5);
    final expected = Numeric(value: '0.11111', precision: 6, scale: 5);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value slightly above maximum', () {
    final upperLimit = Numeric(value: '1.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '0.0', precision: 2, scale: 1);
    final value = Numeric(value: '1.00001', precision: 6, scale: 5);
    final expected = Numeric(value: '1.00000', precision: 6, scale: 5);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value slightly below minimum', () {
    final upperLimit = Numeric(value: '1.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '0.0', precision: 2, scale: 1);
    final value = Numeric(value: '-0.00001', precision: 6, scale: 5);
    final expected = Numeric(value: '0.00000', precision: 6, scale: 5);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if upper bound is fractionally very small', () {
    final upperLimit = Numeric(value: '2.00001', precision: 6, scale: 5);
    final lowerLimit = Numeric(value: '0.0', precision: 2, scale: 1);
    final value = Numeric(value: '2.000001', precision: 8, scale: 7);
    final expected = Numeric(value: '2.000001', precision: 8, scale: 7);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if lower bound is fractionally very small', () {
    final upperLimit = Numeric(value: '2.0', precision: 2, scale: 1);
    final lowerLimit = Numeric(value: '-1.00001', precision: 6, scale: 5);
    final value = Numeric(value: '-1.000001', precision: 8, scale: 7);
    final expected = Numeric(value: '-1.000001', precision: 8, scale: 7);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very large numbers if within bounds', () {
    final upperLimit = Numeric(value: '1e37', precision: 38, scale: 0);
    final lowerLimit = Numeric(value: '1e30', precision: 31, scale: 0);
    final value = Numeric(value: '1e35', precision: 37, scale: 1);
    final expected = Numeric(value: '1e35', precision: 37, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very large numbers if above maximum', () {
    final upperLimit = Numeric(value: '1e37', precision: 38, scale: 0);
    final lowerLimit = Numeric(value: '1e30', precision: 31, scale: 0);
    final value = Numeric(value: '1e38', precision: 40, scale: 1);
    final expected = Numeric(value: '1e37', precision: 40, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very large numbers if below minimum', () {
    final upperLimit = Numeric(value: '1e37', precision: 38, scale: 0);
    final lowerLimit = Numeric(value: '1e30', precision: 31, scale: 0);
    final value = Numeric(value: '1e28', precision: 30, scale: 1);
    final expected = Numeric(value: '1e30', precision: 38, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very small numbers if within bounds', () {
    final upperLimit = Numeric(value: '-1e30', precision: 31, scale: 0);
    final lowerLimit = Numeric(value: '-1e37', precision: 38, scale: 0);
    final value = Numeric(value: '-1e35', precision: 37, scale: 1);
    final expected = Numeric(value: '-1e35', precision: 37, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very small numbers if below minimum', () {
    final upperLimit = Numeric(value: '-1e30', precision: 31, scale: 0);
    final lowerLimit = Numeric(value: '-1e37', precision: 38, scale: 0);
    final value = Numeric(value: '-1e38', precision: 40, scale: 1);
    final expected = Numeric(value: '-1e37', precision: 40, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very small numbers if above maximum', () {
    final upperLimit = Numeric(value: '-1e30', precision: 31, scale: 0);
    final lowerLimit = Numeric(value: '-1e37', precision: 38, scale: 0);
    final value = Numeric(value: '-1e28', precision: 30, scale: 1);
    final expected = Numeric(value: '-1e30', precision: 38, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw ArgumentError if lower bound is greater than upper bound',
      () {
    final upperLimit = Numeric(value: '10.0', precision: 3, scale: 1);
    final lowerLimit = Numeric(value: '20.0', precision: 3, scale: 1);
    final value = Numeric(value: '0', precision: 1, scale: 0);
    expect(() => value.clamp(lowerLimit, upperLimit), throwsArgumentError);
  });
}
