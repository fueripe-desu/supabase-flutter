import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should return 1 if value is positive', () {
    final value = DoublePrecision(3);
    expect(value.sign, 1);
  });

  test('should return 0 if value is zero', () {
    final value = DoublePrecision(0);
    expect(value.sign, 0);
  });

  test('should return -1 if value is negative', () {
    final value = DoublePrecision(-3);
    expect(value.sign, -1);
  });
}
