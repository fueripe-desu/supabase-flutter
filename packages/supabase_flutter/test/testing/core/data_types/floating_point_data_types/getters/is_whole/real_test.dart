import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should return true if value is integer', () {
    final value = Real(3);
    expect(value.isWhole, true);
  });

  test('should return false if value is fractional', () {
    final value = Real(3.5);
    expect(value.isWhole, false);
  });
}
