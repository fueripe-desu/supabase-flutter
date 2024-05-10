import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  // Observation
  // - The value 42 is represented in binary by the number
  // 101010, so it fits in 8 bits.
  test('should work correctly with positive numbers', () {
    final value = Integer(42);
    const bits = 8;
    final expected = Integer(42);
    final operation = value.toUnsigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  // Observation
  // - The resultant value is 31 because -1 in binary
  // is 11111111 in unsigned 2's complement become 00011111.
  test('should work correctly with negative numbers', () {
    final value = Integer(-1);
    const bits = 5;
    final expected = Integer(31);
    final operation = value.toUnsigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  // Observation
  // - The value 15 is represented in binary by the number
  // 1111, so it fits perfectly in 4 bits.
  test(
      'should work correctly with the minimum width to hold the value without truncation',
      () {
    final value = Integer(15);
    const bits = 4;
    final expected = Integer(15);
    final operation = value.toUnsigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  // Observation
  // - The value 5 is represented in binary by the number
  // 101, so if bits are greater than needed, it becomes 00000101.
  test('should work correctly if the width is greater than needed', () {
    final value = Integer(5);
    const bits = 8;
    final expected = Integer(5);
    final operation = value.toUnsigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  // Observation
  // - The value 255 is represented in binary by the number
  // 11111111, so if we only take the last 4 bits, it becomes
  // 15 (or in binary 1111).
  test('should truncate if width is less than needed', () {
    final value = Integer(255);
    const bits = 4;
    final expected = Integer(15);
    final operation = value.toUnsigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  // Observation
  // - The value 256 is represented in binary by the number
  // 100000000, so if we only take the last 8 bits, it becomes
  // 0 (or in binary 00000000).
  test('should wrap around if value exceeds representable range', () {
    final value = Integer(256);
    const bits = 8;
    final expected = Integer(0);
    final operation = value.toUnsigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should work if width is equal to the type bit count', () {
    final value = Integer(Integer.maxValue);
    const bits = 32;
    final expected = Integer(Integer.maxValue);
    final operation = value.toUnsigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should work if width is much larger than the bit count', () {
    final value = Integer(Integer.maxValue);
    const bits = 200;
    final expected = Integer(Integer.maxValue);
    final operation = value.toUnsigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw ArgumentError if width is zero', () {
    final value = Integer(255);
    const bits = 0;
    expect(() => value.toUnsigned(bits), throwsArgumentError);
  });

  test('should throw ArgumentError if width is negative', () {
    final value = Integer(255);
    const bits = -1;
    expect(() => value.toUnsigned(bits), throwsArgumentError);
  });
}
