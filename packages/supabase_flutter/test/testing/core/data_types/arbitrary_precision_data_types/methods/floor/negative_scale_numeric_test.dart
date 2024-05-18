import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return itself if value is positive', () {
    final value = Numeric(value: '14', precision: 2, scale: -1);
    final expected = Numeric(value: '10', precision: 2, scale: 0);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is negative value', () {
    final value = Numeric(value: '-14', precision: 2, scale: -1);
    final expected = Numeric(value: '-10', precision: 2, scale: 0);
    final operation = value.floor();
    expect(operation.identicalTo(expected), true);
  });

  test('should work when given a scale', () {
    final value = Numeric(value: '34', precision: 2, scale: 0);
    final expected = Numeric(value: '30', precision: 2, scale: 0);
    final operation = value.floor(floorScale: -1);
    expect(operation.identicalTo(expected), true);
  });
}
