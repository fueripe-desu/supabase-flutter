import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should work correctly with positive values', () {
    final value = Numeric(value: '0.2', precision: 1, scale: 1);
    final expected = Numeric(value: '1.0', precision: 2, scale: 1);
    final operation = value.ceil();
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative values', () {
    final value = Numeric(value: '-0.7', precision: 1, scale: 1);
    final expected = Numeric(value: '0.0', precision: 1, scale: 1);
    final operation = value.ceil();
    expect(operation.identicalTo(expected), true);
  });

  test('should return 0.0 if value is 0.0', () {
    final value = Numeric(value: '0.0', precision: 1, scale: 1);
    final expected = Numeric(value: '0.0', precision: 1, scale: 1);
    final operation = value.ceil();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle fractionally small near-zero positive value',
      () {
    final value = Numeric(value: '0.00000000000001', precision: 14, scale: 14);
    final expected = Numeric(
      value: '1.00000000000000',
      precision: 15,
      scale: 14,
    );
    final operation = value.ceil();
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly handle fractionally small near-zero negative value',
      () {
    final value = Numeric(value: '-0.00000000000001', precision: 14, scale: 14);
    final expected = Numeric(
      value: '0.00000000000000',
      precision: 14,
      scale: 14,
    );
    final operation = value.ceil();
    expect(operation.identicalTo(expected), true);
  });

  test('should work when given a scale', () {
    final value = Numeric(value: '0.1415', precision: 4, scale: 4);
    final expected = Numeric(value: '0.15', precision: 2, scale: 2);
    final operation = value.ceil(ceilScale: 2);
    expect(operation.identicalTo(expected), true);
  });
}
