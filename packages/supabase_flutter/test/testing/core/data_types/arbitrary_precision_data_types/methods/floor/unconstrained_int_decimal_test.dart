import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return itself if value is positive', () {
    final value = Decimal(value: '10');
    final expected = Decimal(value: '10', precision: 2, scale: 0);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is zero value', () {
    final value = Decimal(value: '0');
    final expected = Decimal(value: '0', precision: 1, scale: 0);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is negative value', () {
    final value = Decimal(value: '-10');
    final expected = Decimal(value: '-10', precision: 2, scale: 0);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should work when given a scale', () {
    final value = Decimal(value: '3');
    final expected = Decimal(value: '3.00', precision: 3, scale: 2);
    final operation = value.floor(floorScale: 2);
    expect(operation.identicalTo(expected), true);
  });
}
