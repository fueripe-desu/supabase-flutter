import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should return the count of decimal places', () {
    final value = DoublePrecision(3.14159);
    expect(value.decimalPlaceCount, 5);
  });

  test('should return 1 if value is integer-valued', () {
    final value = DoublePrecision(3);
    expect(value.decimalPlaceCount, 1);
  });
}
