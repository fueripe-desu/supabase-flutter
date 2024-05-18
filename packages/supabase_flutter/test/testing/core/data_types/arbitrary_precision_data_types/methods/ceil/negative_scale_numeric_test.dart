import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return itself if value is positive', () {
    final value = Numeric(value: '14', precision: 2, scale: -1);
    final expected = Numeric(value: '10', precision: 2, scale: 0);
    final operation = value.ceil();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is zero value', () {
    final value = Numeric(value: '14', precision: 1, scale: -3);
    final expected = Numeric(value: '0', precision: 1, scale: 0);
    final operation = value.ceil();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is negative value', () {
    final value = Numeric(value: '-14', precision: 2, scale: -1);
    final expected = Numeric(value: '-10', precision: 2, scale: 0);
    final operation = value.ceil();
    expect(operation.identicalTo(expected), true);
  });

  test('should work when given a scale', () {
    final value = Numeric(value: '24', precision: 2, scale: -1);
    final expected = Numeric(value: '20.00', precision: 4, scale: 2);
    final operation = value.ceil(ceilScale: 2);
    expect(operation.identicalTo(expected), true);
  });
}
