import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  // Observations:
  // - The value is not affected because 127 (in binary: 1111111)
  // fits perfectly into 7 bits + 1 sign bit, so the actual value
  // shall not change.
  test('should not affect if value fits perfectly', () {
    final value = SmallSerial(127);
    const bits = 8;
    final expected = SmallSerial(127);
    final operation = value.toSigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  // Observations
  // - The resultant value is negative because 128, which is
  // represented in binary by 10000000, is -128 in a signed
  // 2's complement system.
  //
  // But in [Serial types] negative cannot be stored.
  test('should throw RangeError when value causes overflow', () {
    final value = SmallSerial(128);
    const bits = 8;
    expect(() => value.toSigned(bits), throwsRangeError);
  });

  test('should throw RangeError when width is 1 and value binary ends in 1',
      () {
    final value = SmallSerial(1);
    const bits = 1;
    expect(() => value.toSigned(bits), throwsRangeError);
  });

  test('should throw RangeError when width is 1 and value binary ends in 0',
      () {
    final value = SmallSerial(2);
    const bits = 1;
    expect(() => value.toSigned(bits), throwsRangeError);
  });

  test('should work correctly if width is equal to type bit count', () {
    final value = SmallSerial(SmallSerial.maxValue);
    const bits = 16;
    final expected = SmallSerial(SmallSerial.maxValue);
    final operation = value.toSigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should not affect if width is much greater than the type size', () {
    final value = SmallSerial(SmallSerial.maxValue);
    const bits = 660;
    final expected = SmallSerial(SmallSerial.maxValue);
    final operation = value.toSigned(bits);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw ArgumentError if width is zero', () {
    final value = SmallSerial(123);
    const bits = 0;
    expect(() => value.toSigned(bits), throwsArgumentError);
  });

  test('should throw ArgumentError if width is negative', () {
    final value = SmallSerial(123);
    const bits = -1;
    expect(() => value.toSigned(bits), throwsArgumentError);
  });
}
