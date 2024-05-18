import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should work correctly with positive base and exponent', () {
    final baseValue = Numeric(value: '14', precision: 2, scale: -1);
    const exponent = 4;
    final expected = Numeric(value: '10000', precision: 5, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with positive base and zero exponent', () {
    final baseValue = Numeric(value: '14', precision: 2, scale: -1);
    const exponent = 0;
    final expected = Numeric(value: '1', precision: 1, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative base and positive odd exponent',
      () {
    final baseValue = Numeric(value: '-14', precision: 2, scale: -1);
    const exponent = 3;
    final expected = Numeric(value: '-1000', precision: 4, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative base and positive even exponent',
      () {
    final baseValue = Numeric(value: '-14', precision: 2, scale: -1);
    const exponent = 4;
    final expected = Numeric(value: '10000', precision: 5, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with positive base and negative exponent', () {
    final baseValue = Numeric(value: '14', precision: 2, scale: -1);
    const exponent = -1;
    final expected = Numeric(value: '0.1', precision: 2, scale: 1);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative base and negative odd exponent',
      () {
    final baseValue = Numeric(value: '14', precision: 2, scale: -1);
    const exponent = -3;
    final expected = Numeric(value: '0.001', precision: 4, scale: 3);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative base and negative even exponent',
      () {
    final baseValue = Numeric(value: '14', precision: 2, scale: -1);
    const exponent = -4;
    final expected = Numeric(value: '0.0001', precision: 5, scale: 4);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if exponent is 1', () {
    final baseValue = Numeric(value: '14', precision: 2, scale: -1);
    const exponent = 1;
    final expected = Numeric(value: '10', precision: 2, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });

  test('should always return 1 if exponent is 0', () {
    final baseValue = Numeric(value: '14', precision: 2, scale: -1);
    const exponent = 0;
    final expected = Numeric(value: '1', precision: 1, scale: 0);
    final operation = baseValue.pow(exponent);
    expect(operation.identicalTo(expected), true);
  });
}
