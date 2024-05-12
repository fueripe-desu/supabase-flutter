import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should not affect if value is within bounds', () {
    const upperLimit = 1.0;
    const lowerLimit = 0.0;
    final value = Real(0.5);
    final expected = Real(0.5);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should clamp if value is above maximum', () {
    const upperLimit = 1.0;
    const lowerLimit = 0.0;
    final value = Real(1.5);
    final expected = Real(1.0);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should clamp if value is below minimum', () {
    const upperLimit = 1.0;
    const lowerLimit = 0.0;
    final value = Real(-0.1);
    final expected = Real(0.0);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should not affect negative if value is within bounds', () {
    const upperLimit = -2.0;
    const lowerLimit = -4.0;
    final value = Real(-3);
    final expected = Real(-3);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should clamp negative if value is above maximum', () {
    const upperLimit = -2.0;
    const lowerLimit = -4.0;
    final value = Real(-1.5);
    final expected = Real(-2.0);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should clamp negative if value is below minimum', () {
    const upperLimit = -2.0;
    const lowerLimit = -4.0;
    final value = Real(-5);
    final expected = Real(-4.0);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value is equal to the upper bound', () {
    const upperLimit = 1.0;
    const lowerLimit = 0.0;
    final value = Real(1.0);
    final expected = Real(1.0);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value is equal to the lower bound', () {
    const upperLimit = 1.0;
    const lowerLimit = 0.0;
    final value = Real(0.0);
    final expected = Real(0.0);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if negative value is equal to the lower bound',
      () {
    const lowerLimit = -1.0;
    const upperLimit = -0.0;
    final value = Real(-1.0);
    final expected = Real(-1.0);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if negative value is equal to the upper bound',
      () {
    const lowerLimit = -1.0;
    const upperLimit = -0.0;
    final value = Real(-0.0);
    final expected = Real(-0.0);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should work correctly if both upper and lower bound are equal and positive',
      () {
    const lowerLimit = 2.0;
    const upperLimit = 2.0;
    final value = Real(5.0);
    final expected = Real(2.0);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should work correctly if both upper and lower bound are equal and negative',
      () {
    const lowerLimit = -2.0;
    const upperLimit = -2.0;
    final value = Real(5.0);
    final expected = Real(-2.0);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value very close to the upper bound', () {
    const upperLimit = 1.0;
    const lowerLimit = 0.0;
    final value = Real(0.99999);
    final expected = Real(0.99999);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value very close to the lower bound', () {
    const upperLimit = 1.0;
    const lowerLimit = 0.0;
    final value = Real(0.11111);
    final expected = Real(0.11111);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value slightly above maximum', () {
    const upperLimit = 1.0;
    const lowerLimit = 0.0;
    final value = Real(1.00001);
    final expected = Real(1);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value slightly below minimum', () {
    const upperLimit = 1.0;
    const lowerLimit = 0.0;
    final value = Real(-0.00001);
    final expected = Real(0.0);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if upper bound is fractionally very small', () {
    const upperLimit = 2.00001;
    const lowerLimit = 0.0;
    final value = Real(2.000001);
    final expected = Real(2.000001);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if lower bound is fractionally very small', () {
    const upperLimit = 2.0;
    const lowerLimit = -1.00001;
    final value = Real(-1.000001);
    final expected = Real(-1.000001);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very large numbers if within bounds', () {
    const upperLimit = 1e37;
    const lowerLimit = 1e30;
    final value = Real(1e35);
    final expected = Real(1e35);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very large numbers if above maximum', () {
    const upperLimit = 1e37;
    const lowerLimit = 1e30;
    final value = Real(1e38);
    final expected = Real(1e37);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very large numbers if below minimum', () {
    const upperLimit = 1e37;
    const lowerLimit = 1e30;
    final value = Real(1e28);
    final expected = Real(1e30);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very small numbers if within bounds', () {
    const upperLimit = -1e30;
    const lowerLimit = -1e37;
    final value = Real(-1e35);
    final expected = Real(-1e35);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very small numbers if below minimum', () {
    const upperLimit = -1e30;
    const lowerLimit = -1e37;
    final value = Real(-1e38);
    final expected = Real(-1e37);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with very small numbers if above maximum', () {
    const upperLimit = -1e30;
    const lowerLimit = -1e37;
    final value = Real(-1e28);
    final expected = Real(-1e30);
    final operation = value.clamp(lowerLimit, upperLimit);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw ArgumentError if lower bound is greater than upper bound',
      () {
    const upperLimit = 10.0;
    const lowerLimit = 20.0;
    final value = Real(0);
    expect(() => value.clamp(lowerLimit, upperLimit), throwsArgumentError);
  });

  test('should throw ArgumentError if upper bound is NaN', () {
    final value = Real(0);
    expect(() => value.clamp(0, double.nan), throwsArgumentError);
  });

  test('should throw ArgumentError if lower bound is NaN', () {
    final value = Real(0);
    expect(() => value.clamp(double.nan, 0), throwsArgumentError);
  });

  test('should throw ArgumentError if upper bound is infinity', () {
    final value = Real(0);
    expect(() => value.clamp(0, double.infinity), throwsArgumentError);
  });

  test('should throw ArgumentError if lower bound is infinity', () {
    final value = Real(0);
    expect(() => value.clamp(double.infinity, 0), throwsArgumentError);
  });

  test('should throw ArgumentError if upper bound is negative infinity', () {
    final value = Real(0);
    expect(() => value.clamp(0, double.negativeInfinity), throwsArgumentError);
  });

  test('should throw ArgumentError if lower bound is negative infinity', () {
    final value = Real(0);
    expect(() => value.clamp(double.negativeInfinity, 0), throwsArgumentError);
  });
}
