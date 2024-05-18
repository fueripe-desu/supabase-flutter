import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should not affect if value is within bounds', () {
    final upperLimit = Decimal(value: '1.0', precision: 2, scale: 1);
    final lowerLimit = Decimal(value: '0.0', precision: 2, scale: 1);
    final value = Decimal(value: '0.5', precision: 1, scale: 1);
    final expected = Decimal(value: '0.5', precision: 1, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should clamp if value is above maximum', () {
    final upperLimit = Decimal(value: '0.3', precision: 1, scale: 1);
    final lowerLimit = Decimal(value: '0.0', precision: 1, scale: 1);
    final value = Decimal(value: '0.9', precision: 1, scale: 1);
    final expected = Decimal(value: '0.3', precision: 1, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should clamp if value is below minimum', () {
    final upperLimit = Decimal(value: '0.9', precision: 1, scale: 1);
    final lowerLimit = Decimal(value: '0.2', precision: 1, scale: 1);
    final value = Decimal(value: '-0.1', precision: 1, scale: 1);
    final expected = Decimal(value: '0.2', precision: 1, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should not affect negative if value is within bounds', () {
    final upperLimit = Decimal(value: '-0.1', precision: 1, scale: 1);
    final lowerLimit = Decimal(value: '-0.9', precision: 1, scale: 1);
    final value = Decimal(value: '-0.5', precision: 1, scale: 1);
    final expected = Decimal(value: '-0.5', precision: 1, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should clamp negative if value is above maximum', () {
    final upperLimit = Decimal(value: '-0.7', precision: 1, scale: 1);
    final lowerLimit = Decimal(value: '-0.9', precision: 1, scale: 1);
    final value = Decimal(value: '-0.1', precision: 1, scale: 1);
    final expected = Decimal(value: '-0.7', precision: 1, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should clamp negative if value is below minimum', () {
    final upperLimit = Decimal(value: '-0.1', precision: 1, scale: 1);
    final lowerLimit = Decimal(value: '-0.3', precision: 1, scale: 1);
    final value = Decimal(value: '-0.5', precision: 1, scale: 1);
    final expected = Decimal(value: '-0.3', precision: 1, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value is equal to the upper bound', () {
    final upperLimit = Decimal(value: '0.9', precision: 1, scale: 1);
    final lowerLimit = Decimal(value: '0.0', precision: 1, scale: 1);
    final value = Decimal(value: '0.9', precision: 1, scale: 1);
    final expected = Decimal(value: '0.9', precision: 1, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value is equal to the lower bound', () {
    final upperLimit = Decimal(value: '0.9', precision: 1, scale: 1);
    final lowerLimit = Decimal(value: '0.1', precision: 1, scale: 1);
    final value = Decimal(value: '0.1', precision: 1, scale: 1);
    final expected = Decimal(value: '0.1', precision: 1, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if negative value is equal to the lower bound',
      () {
    final lowerLimit = Decimal(value: '-0.9', precision: 1, scale: 1);
    final upperLimit = Decimal(value: '-0.1', precision: 1, scale: 1);
    final value = Decimal(value: '-0.9', precision: 1, scale: 1);
    final expected = Decimal(value: '-0.9', precision: 1, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if negative value is equal to the upper bound',
      () {
    final lowerLimit = Decimal(value: '-0.9', precision: 1, scale: 1);
    final upperLimit = Decimal(value: '-0.1', precision: 1, scale: 1);
    final value = Decimal(value: '-0.1', precision: 1, scale: 1);
    final expected = Decimal(value: '-0.1', precision: 1, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should work correctly if both upper and lower bound are equal and positive',
      () {
    final lowerLimit = Decimal(value: '0.5', precision: 1, scale: 1);
    final upperLimit = Decimal(value: '0.5', precision: 1, scale: 1);
    final value = Decimal(value: '0.9', precision: 1, scale: 1);
    final expected = Decimal(value: '0.5', precision: 1, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should work correctly if both upper and lower bound are equal and negative',
      () {
    final lowerLimit = Decimal(value: '-0.5', precision: 1, scale: 1);
    final upperLimit = Decimal(value: '-0.5', precision: 1, scale: 1);
    final value = Decimal(value: '0.9', precision: 1, scale: 1);
    final expected = Decimal(value: '-0.5', precision: 1, scale: 1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value very close to the upper bound', () {
    final upperLimit = Decimal(value: '1.0', precision: 2, scale: 1);
    final lowerLimit = Decimal(value: '0.0', precision: 2, scale: 1);
    final value = Decimal(value: '0.99999', precision: 5, scale: 5);
    final expected = Decimal(value: '0.99999', precision: 5, scale: 5);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value very close to the lower bound', () {
    final upperLimit = Decimal(value: '1.0', precision: 2, scale: 1);
    final lowerLimit = Decimal(value: '0.0', precision: 2, scale: 1);
    final value = Decimal(value: '0.10001', precision: 5, scale: 5);
    final expected = Decimal(value: '0.10001', precision: 5, scale: 5);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value slightly above maximum', () {
    final upperLimit = Decimal(value: '0.8', precision: 1, scale: 1);
    final lowerLimit = Decimal(value: '0.0', precision: 1, scale: 1);
    final value = Decimal(value: '0.80001', precision: 5, scale: 5);
    final expected = Decimal(value: '0.80000', precision: 5, scale: 5);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value slightly below minimum', () {
    final upperLimit = Decimal(value: '0.9', precision: 1, scale: 1);
    final lowerLimit = Decimal(value: '0.0', precision: 1, scale: 1);
    final value = Decimal(value: '-0.00001', precision: 5, scale: 5);
    final expected = Decimal(value: '0.00000', precision: 5, scale: 5);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if upper bound is fractionally very small', () {
    final upperLimit = Decimal(value: '0.00001', precision: 5, scale: 5);
    final lowerLimit = Decimal(value: '0.0', precision: 1, scale: 1);
    final value = Decimal(value: '0.000001', precision: 6, scale: 6);
    final expected = Decimal(value: '0.000001', precision: 6, scale: 6);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if lower bound is fractionally very small', () {
    final upperLimit = Decimal(value: '0.2', precision: 1, scale: 1);
    final lowerLimit = Decimal(value: '-0.00001', precision: 5, scale: 5);
    final value = Decimal(value: '-0.000001', precision: 6, scale: 6);
    final expected = Decimal(value: '-0.000001', precision: 6, scale: 6);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw ArgumentError if lower bound is greater than upper bound',
      () {
    final upperLimit = Decimal(value: '0.1', precision: 1, scale: 1);
    final lowerLimit = Decimal(value: '0.9', precision: 1, scale: 1);
    final value = Decimal(value: '0.0', precision: 1, scale: 1);
    expect(() => value.clamp(lowerLimit, upperLimit), throwsArgumentError);
  });
}
