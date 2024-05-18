import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return its positive counterpart if value is negative', () {
    final value = Decimal(value: '-0.14', precision: 2, scale: 2);
    final expected = Decimal(value: '0.14', precision: 2, scale: 2);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is already positive', () {
    final value = Decimal(value: '0.14', precision: 2, scale: 2);
    final expected = Decimal(value: '0.14', precision: 2, scale: 2);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });
}
