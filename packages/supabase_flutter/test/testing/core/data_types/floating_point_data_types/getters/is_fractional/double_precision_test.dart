import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should return false if value is integer-valued', () {
    final value = DoublePrecision(3);
    expect(value.isFractional, false);
  });

  test('should return true if value is fractional', () {
    final value = DoublePrecision(3.5);
    expect(value.isFractional, true);
  });
}
