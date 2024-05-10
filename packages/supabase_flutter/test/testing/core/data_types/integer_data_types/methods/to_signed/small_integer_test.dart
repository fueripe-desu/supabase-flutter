import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  // Observations:
  // - The value is not affected because 127 (in binary: 1111111)
  // fits perfectly into 7 bits + 1 sign bit, so the actual value
  // shall not change.
  test('should not affect if value fits perfectly', () {
    final value = SmallInteger(127);
    const bits = 8;
    final expected = SmallInteger(127);
    final operation = value.toSigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  // Observations
  // - The resultant value is negative because 128, which is
  // represented in binary by 10000000, is -128 in a signed
  // 2's complement system.
  test('should work correctly if value causes positive overflow', () {
    final value = SmallInteger(128);
    const bits = 8;
    final expected = SmallInteger(-128);
    final operation = value.toSigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value causes negative overflow', () {
    final value = SmallInteger(-129);
    const bits = 8;
    final expected = SmallInteger(127);
    final operation = value.toSigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should return 0 if value is 0', () {
    final value = SmallInteger(0);
    const bits = 8;
    final expected = SmallInteger(0);
    final operation = value.toSigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should return -1 if width is 1 and value binary ends in 1', () {
    final value = SmallInteger(1);
    const bits = 1;
    final expected = SmallInteger(-1);
    final operation = value.toSigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should return 0 if width is 1 and value binary ends in 0', () {
    final value = SmallInteger(2);
    const bits = 1;
    final expected = SmallInteger(0);
    final operation = value.toSigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if value is negative', () {
    final value = SmallInteger(-1);
    const bits = 8;
    final expected = SmallInteger(-1);
    final operation = value.toSigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly if width is equal to type bit count', () {
    final value = SmallInteger(SmallInteger.maxValue);
    const bits = 16;
    final expected = SmallInteger(SmallInteger.maxValue);
    final operation = value.toSigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should not affect if width is much greater than the type size', () {
    final value = SmallInteger(SmallInteger.maxValue);
    const bits = 660;
    final expected = SmallInteger(SmallInteger.maxValue);
    final operation = value.toSigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw ArgumentError if width is zero', () {
    final value = SmallInteger(123);
    const bits = 0;
    expect(() => value.toSigned(bits), throwsArgumentError);
  });

  test('should throw ArgumentError if width is negative', () {
    final value = SmallInteger(123);
    const bits = -1;
    expect(() => value.toSigned(bits), throwsArgumentError);
  });
}
