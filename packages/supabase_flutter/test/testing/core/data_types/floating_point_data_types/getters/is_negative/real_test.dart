import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should return true if value is negative', () {
    final value = Real(-3);
    expect(value.isNegative, true);
  });

  test('should return false if value is positive', () {
    final value = Real(3);
    expect(value.isNegative, false);
  });
}
