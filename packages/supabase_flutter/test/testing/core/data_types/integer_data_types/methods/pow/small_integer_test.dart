import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should work correctly with positive base and exponent', () {
    final baseValue = SmallInteger(3);
    const exponent = 4;
    final expected = SmallInteger(81);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with zero base and positive exponent', () {
    final baseValue = SmallInteger(0);
    const exponent = 4;
    final expected = SmallInteger(0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with positive base and zero exponent', () {
    final baseValue = SmallInteger(3);
    const exponent = 0;
    final expected = SmallInteger(1);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with zero base and exponent', () {
    final baseValue = SmallInteger(0);
    const exponent = 0;
    final expected = SmallInteger(1);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative base and positive odd exponent',
      () {
    final baseValue = SmallInteger(-2);
    const exponent = 3;
    final expected = SmallInteger(-8);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative base and positive even exponent',
      () {
    final baseValue = SmallInteger(-2);
    const exponent = 4;
    final expected = SmallInteger(16);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should throw ArgumentError when calculating with positive base and negative exponent',
      () {
    final baseValue = SmallInteger(2);
    const exponent = -1;
    expect(() => baseValue.pow(exponent), throwsArgumentError);
  });

  test(
      'should throw ArgumentError when calculating with negative base and negative odd exponent',
      () {
    final baseValue = SmallInteger(2);
    const exponent = -3;
    expect(() => baseValue.pow(exponent), throwsArgumentError);
  });

  test(
      'should throw ArgumentError when calculating with negative base and negative even exponent',
      () {
    final baseValue = SmallInteger(2);
    const exponent = -4;
    expect(() => baseValue.pow(exponent), throwsArgumentError);
  });

  test(
      'should throw ArgumentError when calculating zero base with negative exponent',
      () {
    final baseValue = SmallInteger(0);
    const exponent = -4;
    expect(() => baseValue.pow(exponent), throwsArgumentError);
  });

  test('should return itself if exponent is 1', () {
    final baseValue = SmallInteger(27);
    const exponent = 1;
    final expected = SmallInteger(27);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should always return 1 if exponent is 0', () {
    final baseValue = SmallInteger(27);
    const exponent = 0;
    final expected = SmallInteger(1);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should always return 1 if base is 1', () {
    final baseValue = SmallInteger(1);
    const exponent = 4;
    final expected = SmallInteger(1);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw RangeError if operation overflows', () {
    final baseValue = SmallInteger(2);
    const exponent = 1000;
    expect(() => baseValue.pow(exponent), throwsRangeError);
  });
}
