import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should work correctly with positive base and exponent', () {
    final baseValue = Serial(3);
    const exponent = 4;
    final expected = Serial(81);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with positive base and zero exponent', () {
    final baseValue = Serial(3);
    const exponent = 0;
    final expected = Serial(1);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should throw ArgumentError when calculating zero base with negative exponent',
      () {
    final baseValue = Serial(2);
    const exponent = -4;
    expect(() => baseValue.pow(exponent), throwsArgumentError);
  });

  test('should return itself if exponent is 1', () {
    final baseValue = Serial(27);
    const exponent = 1;
    final expected = Serial(27);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should always return 1 if exponent is 0', () {
    final baseValue = Serial(27);
    const exponent = 0;
    final expected = Serial(1);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should always return 1 if base is 1', () {
    final baseValue = Serial(1);
    const exponent = 4;
    final expected = Serial(1);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw RangeError if operation overflows', () {
    final baseValue = Serial(2);
    const exponent = 1000;
    expect(() => baseValue.pow(exponent), throwsRangeError);
  });
}
