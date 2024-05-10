import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should work correctly with positive base and exponent', () {
    final baseValue = SmallSerial(3);
    const exponent = 4;
    final expected = SmallSerial(81);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with positive base and zero exponent', () {
    final baseValue = SmallSerial(3);
    const exponent = 0;
    final expected = SmallSerial(1);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should throw ArgumentError when calculating zero base with negative exponent',
      () {
    final baseValue = SmallSerial(2);
    const exponent = -4;
    expect(() => baseValue.pow(exponent), throwsArgumentError);
  });

  test('should return itself if exponent is 1', () {
    final baseValue = SmallSerial(27);
    const exponent = 1;
    final expected = SmallSerial(27);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should always return 1 if exponent is 0', () {
    final baseValue = SmallSerial(27);
    const exponent = 0;
    final expected = SmallSerial(1);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should always return 1 if base is 1', () {
    final baseValue = SmallSerial(1);
    const exponent = 4;
    final expected = SmallSerial(1);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw RangeError if operation overflows', () {
    final baseValue = SmallSerial(2);
    const exponent = 1000;
    expect(() => baseValue.pow(exponent), throwsRangeError);
  });
}
