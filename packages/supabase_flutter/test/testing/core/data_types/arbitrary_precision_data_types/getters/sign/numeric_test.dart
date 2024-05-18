import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return 1 if the value is positive', () {
    expect(Numeric(value: '10', precision: 2, scale: 0).sign, 1);
  });

  test('should return 0 if the value is zero', () {
    expect(Numeric(value: '0', precision: 1, scale: 0).sign, 0);
  });

  test('should return -1 if the value is negative', () {
    expect(Numeric(value: '-10', precision: 2, scale: 0).sign, -1);
  });
}
