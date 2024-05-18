import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should work correctly with positive values', () {
    final value = Decimal(value: '3.2');
    final expected = Decimal(value: '3.0', precision: 2, scale: 1);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative values', () {
    final value = Decimal(value: '-3.7');
    final expected = Decimal(value: '-4.0', precision: 2, scale: 1);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is a positive whole number', () {
    final value = Decimal(value: '5.0');
    final expected = Decimal(value: '5.0', precision: 2, scale: 1);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is a negative whole number', () {
    final value = Decimal(value: '-2.0');
    final expected = Decimal(value: '-2.0', precision: 2, scale: 1);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should return 0.0 if value is 0.0', () {
    final value = Decimal(value: '0.0');
    final expected = Decimal(value: '0.0', precision: 2, scale: 1);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle fractionally small near-zero positive value',
      () {
    final value = Decimal(value: '0.00000000000001');
    final expected = Decimal(
      value: '0.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle fractionally small near-zero negative value',
      () {
    final value = Decimal(value: '-0.00000000000001');
    final expected = Decimal(
      value: '-1.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle positive numbers very close to an integer', () {
    final value = Decimal(value: '2.99999999999999');
    final expected =
        Decimal(value: '2.00000000000000', precision: 15, scale: 14);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle negative numbers very close to an integer', () {
    final value = Decimal(value: '-2.99999999999999');
    final expected = Decimal(
      value: '-3.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle positive values with small fractional part',
      () {
    final value = Decimal(value: '1.00000000000001');
    final expected = Decimal(
      value: '1.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle negative values with small fractional part',
      () {
    final value = Decimal(value: '-1.00000000000001');
    final expected = Decimal(
      value: '-2.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should work when given a scale', () {
    final value = Decimal(value: '3.1415');
    final expected = Decimal(value: '3.14', precision: 3, scale: 2);
    final operation = value.floor(floorScale: 2);
    expect(operation.identicalTo(expected), true);
  });
}
