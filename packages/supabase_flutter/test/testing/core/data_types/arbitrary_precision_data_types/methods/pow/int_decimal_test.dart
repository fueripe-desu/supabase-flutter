import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should work correctly with positive base and exponent', () {
    final baseValue = Decimal(value: '3', precision: 1, scale: 0);
    const exponent = 4;
    final expected = Decimal(value: '81', precision: 2, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with zero base and positive exponent', () {
    final baseValue = Decimal(value: '0', precision: 1, scale: 0);
    const exponent = 4;
    final expected = Decimal(value: '0', precision: 1, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with positive base and zero exponent', () {
    final baseValue = Decimal(value: '3', precision: 1, scale: 0);
    const exponent = 0;
    final expected = Decimal(value: '1', precision: 1, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with zero base and exponent', () {
    final baseValue = Decimal(value: '0', precision: 1, scale: 0);
    const exponent = 0;
    final expected = Decimal(value: '1', precision: 1, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative base and positive odd exponent',
      () {
    final baseValue = Decimal(value: '-2', precision: 1, scale: 0);
    const exponent = 3;
    final expected = Decimal(value: '-8', precision: 1, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative base and positive even exponent',
      () {
    final baseValue = Decimal(value: '-2', precision: 1, scale: 0);
    const exponent = 4;
    final expected = Decimal(value: '16', precision: 2, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with positive base and negative exponent', () {
    final baseValue = Decimal(value: '2', precision: 1, scale: 0);
    const exponent = -1;
    final expected = Decimal(value: '0.5', precision: 2, scale: 1);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative base and negative odd exponent',
      () {
    final baseValue = Decimal(value: '2', precision: 1, scale: 0);
    const exponent = -3;
    final expected = Decimal(value: '0.125', precision: 4, scale: 3);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative base and negative even exponent',
      () {
    final baseValue = Decimal(value: '2', precision: 1, scale: 0);
    const exponent = -4;
    final expected = Decimal(value: '0.0625', precision: 5, scale: 4);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should throw ArgumentError when calculating zero base with negative exponent',
      () {
    final baseValue = Decimal(value: '0', precision: 1, scale: 0);
    const exponent = -4;
    expect(() => baseValue.pow(exponent), throwsArgumentError);
  });

  test('should return itself if exponent is 1', () {
    final baseValue = Decimal(value: '27', precision: 2, scale: 0);
    const exponent = 1;
    final expected = Decimal(value: '27', precision: 2, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should always return 1 if exponent is 0', () {
    final baseValue = Decimal(value: '27', precision: 2, scale: 0);
    const exponent = 0;
    final expected = Decimal(value: '1', precision: 1, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should always return 1 if base is 1', () {
    final baseValue = Decimal(value: '1', precision: 1, scale: 0);
    const exponent = 4;
    final expected = Decimal(value: '1', precision: 1, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });
}
